import 'package:rep_rise/domain/entity/workout/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({required Map<String, List<WorkoutExerciseModel>> super.schedule, required super.progress});

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final scheduleData = data['schedule'] as Map<String, dynamic>? ?? {};
    final progressData = data['progress'] as Map<String, dynamic>? ?? {};

    final Map<String, List<WorkoutExerciseModel>> scheduleModel = {};
    scheduleData.forEach((day, exercises) {
      if (exercises is List) {
        scheduleModel[day] = exercises.map((e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    });

    final Map<String, bool> progressModel = progressData.map((key, value) => MapEntry(key, value as bool));

    return WorkoutModel(schedule: scheduleModel, progress: progressModel);
  }

  WorkoutEntity toEntity() {
    final Map<String, List<WorkoutExerciseEntity>> entitySchedule = {};

    schedule.forEach((day, exercises) {
      entitySchedule[day] = exercises.map((e) => (e as WorkoutExerciseModel).toEntity()).toList();
    });

    return WorkoutEntity(schedule: entitySchedule, progress: progress); // PASS PROGRESS HERE
  }
}

class WorkoutExerciseModel extends WorkoutExerciseEntity {
  const WorkoutExerciseModel({
    required super.name,
    required super.sets,
    required super.reps,
    required super.restTime,
    required super.targetMuscle,
    required super.bodyPart,
    required super.videoUrl,
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      name: json['exercise'] ?? 'Unknown',
      sets: json['sets']?.toString() ?? '0',
      reps: json['reps']?.toString() ?? '0',
      restTime: json['rest_time'] ?? '60s',
      targetMuscle: json['target_muscle'] ?? '',
      bodyPart: json['body_part'] ?? '',
      videoUrl: json['video_url'],
    );
  }

  WorkoutExerciseEntity toEntity() {
    return WorkoutExerciseEntity(
      name: name,
      sets: sets,
      reps: reps,
      restTime: restTime,
      targetMuscle: targetMuscle,
      bodyPart: bodyPart,
      videoUrl: videoUrl,
    );
  }
}
