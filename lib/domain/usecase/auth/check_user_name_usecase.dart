import 'package:rep_rise/domain/repositories/auth_repository.dart';

class CheckUsernameUseCase {
  final AuthRepository authRepository;

  CheckUsernameUseCase(this.authRepository);

  Future<bool> execute(String username) async {
    return await authRepository.checkUsername(username);
  }
}