import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<bool> execute(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password cannot be empty');
    }

    await authRepository.login(username, password);
    return true;
  }
}