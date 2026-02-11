import '../../repositories/authentication/auth_repository.dart';
import '../../entity/authentication/user_registration_entity.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  Future<void> execute(UserRegistrationEntity newUser) async {
    return await authRepository.register(newUser);
  }
}