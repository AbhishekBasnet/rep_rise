import '../../repositories/auth_repository.dart';
import '../../../core/services/token_service.dart';

class LogoutUseCase {
  final AuthRepository authRepository;
  final TokenService tokenService;

  LogoutUseCase({
    required this.authRepository,
    required this.tokenService,
  });

  Future<void> execute(String refreshToken) async {
    await authRepository.logout(refreshToken);

    await tokenService.clearTokens();
  }
}