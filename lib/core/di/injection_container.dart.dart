import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rep_rise/core/services/health_steps_service.dart';
import 'package:rep_rise/data/data_sources/local/step/step_local_data_source.dart';
import 'package:rep_rise/data/data_sources/remote/step_remote_data_source.dart';
import 'package:rep_rise/data/repositories/profile_repository_impl.dart';
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

final sl = GetIt.instance;

Future<void> init() async {
  // [A] --------- local db (draft) -----------
  // Data Sources
  // 1. Local Database with persistence
  sl.registerLazySingleton<AppDatabase>(() {
    final executor = LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      debugPrint('📂 at DI : OPENING DATABASE AT: ${file.path}');
      return NativeDatabase(file);
    });
    return AppDatabase(executor);
  });
  sl.registerLazySingleton<StepLocalDataSource>(() => StepLocalDataSourceImpl(db: sl<AppDatabase>()));

  // [B] ----------- Services -------------
  sl.registerLazySingleton(() => TokenService());
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => HealthService());
  sl.registerLazySingleton(() => StepRemoteDataSource(client: sl()));

  // [C] -------- Repositories ---------
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<StepRepository>(
    () => StepRepositoryImpl(remoteDataSource: sl(), healthService: sl(), stepLocalDataSource: sl()),
  );
  // register the Interface <ProfileRepository>, but we return the Implementation (ProfileRepositoryImpl)
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));

  // [D] ---------- Use Cases ------------
  //  Auth and Profile Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(tokenService: sl(), authRepository: sl()));
  sl.registerLazySingleton(() => CheckUsernameUseCase(sl()));
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));
  // Step Use Cases
  sl.registerLazySingleton(() => GetDailyStepUsecase(sl()));
  sl.registerLazySingleton(() => GetWeeklyStepUsecase(sl()));
  sl.registerLazySingleton(() => GetMonthlyStepUsecase(sl()));
  sl.registerLazySingleton(() => SyncStepsUseCase(sl()));

  // [C] ---------- Providers ------------
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
