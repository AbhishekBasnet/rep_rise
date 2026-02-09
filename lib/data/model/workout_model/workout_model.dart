import 'package:rep_rise/domain/entity/workout/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({required Map<String, List<WorkoutExerciseModel>> super.schedule});

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    final scheduleData = json['data'] as Map<String, dynamic>;

    final Map<String, List<WorkoutExerciseModel>> scheduleModel = {};

    scheduleData.forEach((day, exercises) {
      if (exercises is List) {
        scheduleModel[day] = exercises.map((e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    });

    return WorkoutModel(schedule: scheduleModel);
  }

  WorkoutEntity toEntity() {
    final Map<String, List<WorkoutExerciseEntity>> entitySchedule = {};

    schedule.forEach((day, exercises) {
      entitySchedule[day] = exercises.map((e) => (e as WorkoutExerciseModel).toEntity()).toList();
    });

    return WorkoutEntity(schedule: entitySchedule);
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
  });

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      name: json['exercise'] ?? 'Unknown',
      sets: json['sets']?.toString() ?? '0',
      reps: json['reps']?.toString() ?? '0',
      restTime: json['rest_time'] ?? '60s',
      targetMuscle: json['target_muscle'] ?? '',
      bodyPart: json['body_part'] ?? '',
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
    );
  }
}
