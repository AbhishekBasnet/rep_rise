import 'package:get_it/get_it.dart';
import 'package:rep_rise/core/services/health_steps_service.dart';
import 'package:rep_rise/data/data_sources/step_remote_data_source.dart';
import 'package:rep_rise/data/repositories/profile_repository_impl.dart';
import 'package:rep_rise/data/repositories/step_repository_impl.dart';
import 'package:rep_rise/domain/entity/user_profile_data_entity.dart';
import 'package:rep_rise/domain/repositories/profile_repository.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';
import 'package:rep_rise/domain/usecase/auth/check_usern_name_usecase.dart';
import 'package:rep_rise/domain/usecase/profile/create_profile_usecase.dart';
import 'package:rep_rise/presentation/provider/profile_setup_provider.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecase/auth/check_auth_status_usecase.dart';
import '../../domain/usecase/auth/login_usecase.dart';
import '../../domain/usecase/auth/logout_usecase.dart';
import '../../domain/usecase/auth/register_usecase.dart';
import '../../presentation/provider/auth_provider.dart';
import '../network/api_client.dart';
import '../services/token_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => TokenService());
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => HealthService());
  sl.registerLazySingleton(() => StepRemoteDataSource(client: sl()));


// --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<StepRepository>(() => StepRepositoryImpl(
    remoteDataSource: sl(),
    healthService: sl(),
  ));

  // register the Interface <ProfileRepository>, but we return the Implementation (ProfileRepositoryImpl)
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(sl()),
  );



  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(tokenService: sl(), authRepository: sl()));
  sl.registerLazySingleton(() => CheckUsernameUseCase(sl()));
  sl.registerLazySingleton(() => CreateProfileUseCase(sl()));

// --- Providers ---
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
}
