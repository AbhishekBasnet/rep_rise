import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final WorkoutSummaryEntity summary;
  final Map<String, List<WorkoutExerciseEntity>> schedule;

  const WorkoutEntity({
    required this.summary,
    required this.schedule,
  });

  @override
  List<Object?> get props => [summary, schedule];
}

class WorkoutSummaryEntity extends Equatable {
  final String goal;
  final String level;
  final String split;

  const WorkoutSummaryEntity({
    required this.goal,
    required this.level,
    required this.split,
  });

  @override
  List<Object?> get props => [goal, level, split];
}

class WorkoutExerciseEntity extends Equatable {
  final String name;
  final String sets;
  final String reps;

  const WorkoutExerciseEntity({
    required this.name,
    required this.sets,
    required this.reps,
  });

  @override
  List<Object?> get props => [name, sets, reps];
}