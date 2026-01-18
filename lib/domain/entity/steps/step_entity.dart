import 'package:equatable/equatable.dart';
class StepEntity extends Equatable {
  final DateTime date;
  final int steps;
  final int goal;
  final String? dayName;

  const StepEntity({required this.date, required this.steps, this.goal = 0, this.dayName});
  double get progressPercentage {
    if (goal == 0) return 0.0;
    double percent = steps / goal;
    return percent > 1.0 ? 1.0 : percent;
  }
  @override
  List<Object?> get props => [date, steps, goal, dayName];
}
