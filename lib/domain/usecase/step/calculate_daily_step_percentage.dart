import 'package:rep_rise/domain/entity/steps/step_entity.dart';

class CalculateDailyStepPercentage {
  final StepEntity stepEntity;

  const CalculateDailyStepPercentage({required this.stepEntity});

  Future<double> execute() async {
    return stepEntity.progressPercentage;
  }
}