import 'package:get_it/get_it.dart';

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

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(sl(), sl())
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl(), tokenService: sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(tokenService: sl()));

  sl.registerFactory(() => AuthProvider(
    checkAuthStatusUseCase: sl(),
    loginUseCase: sl(),
    registerUseCase: sl(),
    logoutUseCase: sl(),
  ));
}