import 'package:rep_rise/domain/repositories/step_repository.dart';

import '../../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository authRepository;
  final StepRepository stepRepository;

  LogoutUseCase({required this.authRepository, required this.stepRepository});

  Future<void> execute() async {
    await stepRepository.clearLocalCache();
    await authRepository.logout();
  }
}
