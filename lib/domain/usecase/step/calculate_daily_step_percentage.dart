import 'package:rep_rise/domain/entity/steps/daily_step_entity.dart';

class CalculateDailyStepPercentage {
  final DailyStepEntity stepEntity;

  const CalculateDailyStepPercentage({required this.stepEntity});

  Future<double> execute() async {
    return stepEntity.progressPercentage;
  }
}