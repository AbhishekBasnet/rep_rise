import 'package:rep_rise/domain/repositories/authentication/auth_repository.dart';

class CheckUsernameUseCase {
  final AuthRepository authRepository;

  CheckUsernameUseCase({required this.authRepository});

  Future<bool> execute(String username) async {
    return await authRepository.checkUsername(username);
  }
}