import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  /// Executes the login logic.
  /// Returns true if successful, throws an exception otherwise.
  Future<bool> execute(String username, String password) async {
    // TODO: can add business logic here (e.g., validation) before calling the repository.
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password cannot be empty');
    }

    await authRepository.login(username, password);
    return true;
  }
}