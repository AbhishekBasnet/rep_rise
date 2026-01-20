import 'package:equatable/equatable.dart';

class WeeklyStepEntity extends Equatable {
  final DateTime date;
  final int steps;
  final int goal;
  final String dayName;


  const WeeklyStepEntity({
    required this.date,
    required this.steps,
    required this.goal,
    required this.dayName,
 
  });


  @override
  List<Object?> get props => [date, steps, goal, dayName];
}
