import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rep_rise/core/services/health_steps_service.dart';
import 'package:rep_rise/data/data_sources/local/step/step_local_data_source.dart';
import 'package:rep_rise/data/data_sources/remote/step_remote_data_source.dart';
import 'package:rep_rise/data/repositories/profile/register_profile_repository_impl.dart';
import 'package:rep_rise/data/repositories/step_repository_impl.dart';
import 'package:rep_rise/domain/repositories/profile_repository.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';
import 'package:rep_rise/domain/usecase/auth/check_user_name_usecase.dart';
import 'package:rep_rise/domain/usecase/profile/create_profile_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_daily_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_monthly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_weekly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/sync_step_usecase.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';
import 'package:rep_rise/presentation/provider/step_provider/step_provider.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecase/auth/check_auth_status_usecase.dart';
import '../../domain/usecase/auth/login_usecase.dart';
import '../../domain/usecase/auth/logout_usecase.dart';
import '../../domain/usecase/auth/register_usecase.dart';
import '../../presentation/provider/auth_provider.dart';
import '../network/api_client.dart';
import '../services/token_service.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

/*
 * ----------------------------------------------------------------------------
 * Dependency Injection (DI) Configuration
 * ----------------------------------------------------------------------------
 * This module implements the Service Locator pattern using `GetIt` to decouple
 * implementation details from the abstraction layers.
 *
 * Initialization Flow & Dependency Graph:
 * ---------------------------------------
 * The registration order strictly adheres to Clean Architecture principles,
 * building the dependency graph from the bottom up:
 *
 * 1. External & Core Layer:
 * - Foundation services (Database, Network Client, Hardware APIs).
 * - These have no internal dependencies.
 *
 * 2. Data Layer:
 * - Data Sources (Remote/Local) -> injected with Core services.
 * - Repositories -> injected with Data Sources.
 *
 * 3. Domain Layer:
 * - Use Cases -> injected with Repositories (Interfaces).
 * - These encapsulate pure business logic.
 *
 * 4. Presentation Layer:
 * - State Providers (ChangeNotifier/Bloc) -> injected with Use Cases.
 * - Registered as Factories to ensure fresh state or disposal on demand.
 *
 * Note: `registerLazySingleton` is favored for memory optimization, ensuring
 * objects are instantiated only upon the first request.
 * ----------------------------------------------------------------------------
 */

/// The global Service Locator instance.
///
/// Use this instance to retrieve registered dependencies anywhere in the app.
/// Example: `final repository = sl<AuthRepository>();`
final sl = GetIt.instance;

/// Asynchronously initializes the entire application dependency graph.
///
/// This method must be awaited in `main()` before `runApp` is called to ensure
/// critical infrastructure (Database, API Clients) is ready.
///
/// Key responsibilities:
/// * Resolves platform-specific paths for the Local Database (Drift).
/// * Registers Singleton instances for Repositories and Services.
/// * Registers Factory instances for UI Providers.
Future<void> init() async {
  // ---------------------------------------------------------------------------
  // Core & External Services
  // ---------------------------------------------------------------------------
  // Configuration for Drift (SQLite) running on a background isolate
  // to prevent UI jank during heavy I/O operations.
  // Data Sources
  // 1. Local Database with persistence
  sl.registerLazySingleton<AppDatabase>(() {
    final executor = LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      debugPrint('📂 at DI : OPENING DATABASE AT: ${file.path}');
      return NativeDatabase.createInBackground(file);
    });
    return AppDatabase(executor);
  });
  sl.registerLazySingleton<StepLocalDataSource>(() => StepLocalDataSourceImpl(db: sl<AppDatabase>()));

  // ---------------------------------------------------------------------------
  // Infrastructure Services
  // ---------------------------------------------------------------------------
  // Low-level services for Token management, API communication, and Health APIs.
  sl.registerLazySingleton(() => TokenService());
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => HealthService());
  sl.registerLazySingleton(() => StepRemoteDataSource(client: sl()));

  // ---------------------------------------------------------------------------
  // Data Repositories
  // ---------------------------------------------------------------------------
  // Repositories hide the data origin (Local vs Remote) from the Domain layer.
  // We register the Interface <T> but return the Implementation <TImpl>.
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<StepRepository>(
    () => StepRepositoryImpl(remoteDataSource: sl(), healthService: sl(), stepLocalDataSource: sl()),
  );
  // register the Interface <ProfileRepository>, but we return the Implementation (ProfileRepositoryImpl)
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));

  // ---------------------------------------------------------------------------
  // Domain Use Cases
  // ---------------------------------------------------------------------------
  // Atomic business logic units. Each Use Case corresponds to a single user action or data calculation.
  //  Auth and Profile Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl(), stepRepository: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(tokenService: sl(), authRepository: sl()));
  sl.registerLazySingleton(() => CheckUsernameUseCase(sl()));
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));
  // Step Use Cases
  sl.registerLazySingleton(() => GetDailyStepUsecase(sl()));
  sl.registerLazySingleton(() => GetWeeklyStepUsecase(sl()));
  sl.registerLazySingleton(() => GetMonthlyStepUsecase(sl()));
  sl.registerLazySingleton(() => SyncStepsUseCase(sl()));

  // ---------------------------------------------------------------------------
  // Presentation Layer (State Management)
  // ---------------------------------------------------------------------------
  // Registered as Factories (`registerFactory`) to ensure a new instance is
  // created whenever the UI requires it (e.g., entering a screen).
  sl.registerFactory(() => ProfileSetupProvider());

  sl.registerFactory(
    () => AuthProvider(
      checkAuthStatusUseCase: sl(),
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      checkUsernameUseCase: sl(),
      createProfileUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => StepProvider(
      getDailyStepUsecase: sl(),
      getWeeklyStepUsecase: sl(),
      getMonthlyStepUsecase: sl(),
      syncStepsUseCase: sl(),
    ),
  );
}
