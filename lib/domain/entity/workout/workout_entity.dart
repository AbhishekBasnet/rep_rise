import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final Map<String, List<WorkoutExerciseEntity>> schedule;

  const WorkoutEntity({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

class WorkoutExerciseEntity extends Equatable {
  final String name;
  final String sets;
  final String reps;
  final String restTime;
  final String targetMuscle;
  final String bodyPart;

  const WorkoutExerciseEntity({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.targetMuscle,
    required this.bodyPart,
  });

  @override
  List<Object?> get props => [name, sets, reps, restTime, targetMuscle, bodyPart];
}
