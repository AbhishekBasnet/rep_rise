import 'package:rep_rise/domain/entity/workout/workout_entity.dart';

class WorkoutModel extends WorkoutEntity {
  const WorkoutModel({
    required WorkoutSummaryModel super.summary,
    required Map<String, List<WorkoutExerciseModel>> super.schedule,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    final summaryData = data['summary'] as Map<String, dynamic>;
    final summaryModel = WorkoutSummaryModel.fromJson(summaryData);

    final scheduleData = data['schedule'] as Map<String, dynamic>;
    final Map<String, List<WorkoutExerciseModel>> scheduleModel = {};

    scheduleData.forEach((day, exercises) {
      if (exercises is List) {
        scheduleModel[day] = exercises.map((e) => WorkoutExerciseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    });

    return WorkoutModel(summary: summaryModel, schedule: scheduleModel);
  }

  WorkoutEntity toEntity() {
    return WorkoutEntity(
      summary: (summary as WorkoutSummaryModel).toEntity(),
      schedule: schedule.map(
        (key, value) => MapEntry(key, value.map((e) => (e as WorkoutExerciseModel).toEntity()).toList()),
      ),
    );
  }
}

class WorkoutSummaryModel extends WorkoutSummaryEntity {
  const WorkoutSummaryModel({required super.goal, required super.level, required super.split});

  factory WorkoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSummaryModel(goal: json['goal'] ?? '', level: json['level'] ?? '', split: json['split'] ?? '');
  }

  WorkoutSummaryEntity toEntity() {
    return WorkoutSummaryEntity(goal: goal, level: level, split: split);
  }
}

class WorkoutExerciseModel extends WorkoutExerciseEntity {
  const WorkoutExerciseModel({required super.name, required super.sets, required super.reps});

  factory WorkoutExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseModel(
      name: json['Workout'] ?? 'Unknown',
      sets: json['Sets'] ?? '0',
      reps: json['Reps per Set'] ?? '0',
    );
  }

  WorkoutExerciseEntity toEntity() {
    return WorkoutExerciseEntity(name: name, sets: sets, reps: reps);
  }
}
