import 'package:equatable/equatable.dart';

class DailyStepEntity extends Equatable {
  final DateTime date;
  final int steps;
  final int goal;
  final String? dayName;
  final double caloriesBurned;
  final double distanceMeters;
  final int durationMinutes;

  const DailyStepEntity({
    required this.date,
    required this.steps,
    this.goal = 0,
    this.dayName,
    required this.caloriesBurned,
    required this.distanceMeters,
    required this.durationMinutes,
  });
  double get progressPercentage {
    if (goal == 0) return 0.0;
    double percent = steps / goal;
    return percent > 1.0 ? 1.0 : percent;
  }

  @override
  List<Object?> get props => [date, steps, goal, dayName];
}
