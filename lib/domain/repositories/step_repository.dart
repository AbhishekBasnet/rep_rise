import '../entity/step_entity.dart';

abstract class StepRepository {
  Future<void> syncSteps();

  Future<List<StepEntity>> getStepHistory(String period);
}