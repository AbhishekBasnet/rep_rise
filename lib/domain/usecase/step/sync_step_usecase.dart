import 'package:rep_rise/domain/repositories/step_repository.dart';

class SyncStepsUseCase {
  final StepRepository repository;

  SyncStepsUseCase(this.repository);

  Future<void> execute() async {
    return repository.syncSteps();
  }
}