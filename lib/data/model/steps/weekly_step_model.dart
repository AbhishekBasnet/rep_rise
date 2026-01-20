import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';
import 'package:rep_rise/domain/entity/steps/weekly_step_entity.dart';
import '../../../domain/entity/steps/daily_step_entity.dart';

class WeeklyStepModel extends WeeklyStepEntity {
  const WeeklyStepModel({
    required super.date,
    required super.steps,
    required super.goal, required super.dayName,

  });

  factory WeeklyStepModel.fromJson(Map<String, dynamic> json) {
    final rawDate = DateTime.parse(json['date']);
    final cleanDate = DateTime(rawDate.year, rawDate.month, rawDate.day);

    return WeeklyStepModel(
      date: cleanDate,
      steps: (json['steps'] as num).toInt(),
      goal: (json['goal'] ?? 0) as int,
      dayName: json['day_name'],

    );
  }
  WeeklyStepEntity toEntity() {
    return WeeklyStepEntity(
      date: date,
      steps: steps,
      goal: goal,
      dayName: dayName,
    );
  }
}

class StepSummaryModel extends StepSummaryEntity {
  const StepSummaryModel({required super.totalSteps, required super.totalGoal, required super.avgGoal});

  factory StepSummaryModel.fromJson(Map<String, dynamic> json) {
    return StepSummaryModel(
      totalSteps: (json['total_steps'] as num).toInt(),
      totalGoal: (json['total_goal'] as num).toInt(),
      avgGoal: (json['avg_goal'] as num).toInt(),
    );
  }

  StepSummaryEntity toEntity() {
    return StepSummaryEntity(totalSteps: totalSteps, totalGoal: totalGoal, avgGoal: avgGoal);
  }
}
