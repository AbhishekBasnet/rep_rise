import 'package:rep_rise/domain/repositories/step/step_repository.dart';

class SyncStepsUseCase {
  final StepRepository stepRepository;

  SyncStepsUseCase({required this.stepRepository});

  Future<void> execute() async {
    return stepRepository.syncSteps();
  }
}