import '../../repositories/auth_repository.dart';
import '../../entity/auth/user_registration_entity.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<void> execute(UserRegistrationEntity newUser) async {
    return await authRepository.register(newUser);
  }
}