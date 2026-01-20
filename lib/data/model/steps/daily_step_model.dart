import 'package:rep_rise/core/util/extension/to_precision.dart';
import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';
import '../../../domain/entity/steps/daily_step_entity.dart';

class DailyStepModel extends DailyStepEntity {
  const DailyStepModel({
    required super.date,
    required super.steps,
    required super.goal,
    super.dayName,
    required super.caloriesBurned,
    required super.distanceMeters,
    required super.durationMinutes,
  });

  factory DailyStepModel.fromJson(Map<String, dynamic> json) {
    final rawDate = DateTime.parse(json['date']);
    final cleanDate = DateTime(rawDate.year, rawDate.month, rawDate.day);

    return DailyStepModel(
      date: cleanDate,
      steps: (json['steps'] as num).toInt(),
      goal: (json['goal'] ?? 0) as int,
      dayName: json['day_name'],
      caloriesBurned: (json['calories_burned'] as num).toDouble().toPrecision(2),
      distanceMeters: (json['distance_meters'] as num).toDouble().toPrecision(2),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
    );
  }
  DailyStepEntity toEntity() {
    return DailyStepEntity(
      date: date,
      steps: steps,
      goal: goal,
      dayName: dayName,
      caloriesBurned: caloriesBurned,
      distanceMeters: distanceMeters,
      durationMinutes: durationMinutes,
    );
  }
}
