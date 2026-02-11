import 'package:equatable/equatable.dart';

class WorkoutEntity extends Equatable {
  final Map<String, List<WorkoutExerciseEntity>> schedule;
  final Map<String, bool> progress;

  const WorkoutEntity({required this.schedule, required this.progress});

  @override
  List<Object?> get props => [schedule, progress];
}

class WorkoutExerciseEntity extends Equatable {
  final String name;
  final String sets;
  final String reps;
  final String restTime;
  final String targetMuscle;
  final String bodyPart;
  final String? videoUrl;

  const WorkoutExerciseEntity({
    required this.name,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.targetMuscle,
    required this.bodyPart,
    required this.videoUrl,
  });

  @override
  List<Object?> get props => [name, sets, reps, restTime, targetMuscle, bodyPart, videoUrl];
}
