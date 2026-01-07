import '../../repositories/auth_repository.dart';
import '../../../core/services/token_service.dart';

class LogoutUseCase {
  final AuthRepository authRepository;

  LogoutUseCase({
    required this.authRepository,
  });

  Future<void> execute() async {

    await authRepository.logout();//TODO tokens arent being saved on local storage on registration
  }
}