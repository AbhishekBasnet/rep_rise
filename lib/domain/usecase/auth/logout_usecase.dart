import '../../repositories/auth_repository.dart';
import '../../../core/services/token_service.dart';

class LogoutUseCase {
  final AuthRepository authRepository;

  LogoutUseCase({
    required this.authRepository,
  });

  Future<void> execute() async {

    await authRepository.logout();
  }
}