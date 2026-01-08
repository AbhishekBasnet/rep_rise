import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';

import '../../../domain/entity/steps/step_entity.dart';

class StepEntryModel extends StepEntity {
  const StepEntryModel({
    required DateTime date,
    required int steps,
    int? goal,
   String? dayName,
  }) : super(date: date, steps: steps, goal: goal, dayName: dayName);

  factory StepEntryModel.fromJson(Map<String, dynamic> json) {
    return StepEntryModel(
      date: DateTime.parse(json['date']),
      steps: json['steps'],

      goal: json['goal'] ?? json['goal_per_day'] ?? 0, 
      dayName: json['day_name'],
    );
  }
}

class StepSummaryModel extends StepSummaryEntity {
  const StepSummaryModel({
    required super.totalSteps,
    required super.totalGoal,
    required super.avgGoal,
  });

  factory StepSummaryModel.fromJson(Map<String, dynamic> json) {
    return StepSummaryModel(
      totalSteps: json['total_steps'],
      totalGoal: json['total_goal'],
      avgGoal: (json['avg_goal'] as num).toDouble(),
    );
  }
}