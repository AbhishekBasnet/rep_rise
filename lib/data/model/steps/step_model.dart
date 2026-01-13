import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';

import '../../../domain/entity/steps/step_entity.dart';

class StepModel extends StepEntity {
  const StepModel({required DateTime date, required int steps, required int goal, String? dayName})
    : super(date: date, steps: steps, goal: goal, dayName: dayName);

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      date: DateTime.parse(json['date']),
      steps: (json['steps'] as num).toInt(),

      goal: (json['goal'] ?? json['goal_per_day'] ?? 0) as int,

      dayName: json['day_name'],
    );
  }
  StepEntity toEntity() {
    return StepEntity(date: date, steps: steps, goal: goal, dayName: dayName);
  }
}

class StepSummaryModel extends StepSummaryEntity {
  const StepSummaryModel({required int totalSteps, required int totalGoal, required double avgGoal})
    : super(totalSteps: totalSteps, totalGoal: totalGoal, avgGoal: avgGoal);

  factory StepSummaryModel.fromJson(Map<String, dynamic> json) {
    return StepSummaryModel(
      totalSteps: (json['total_steps'] as num).toInt(),
      totalGoal: (json['total_goal'] as num).toInt(),

      avgGoal: (json['avg_goal'] as num).toDouble(),
    );
  }

  StepSummaryEntity toEntity() {
    return StepSummaryEntity(totalSteps: totalSteps, totalGoal: totalGoal, avgGoal: avgGoal);
  }
}
