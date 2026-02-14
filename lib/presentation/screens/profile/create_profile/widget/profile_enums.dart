enum FitnessGoal {
  weightLoss,
  muscleGain,
}

extension FitnessGoalExtension on FitnessGoal {
  String get apiValue {
    switch (this) {
      case FitnessGoal.weightLoss:
        return 'weight_loss';
      case FitnessGoal.muscleGain:
        return 'muscle_gain';

    }
  }

  String get displayName {
    switch (this) {
      case FitnessGoal.weightLoss:
        return 'Weight Loss';
      case FitnessGoal.muscleGain:
        return 'Muscle Gain';

    }
  }

  static FitnessGoal fromString(String value) {
    return FitnessGoal.values.firstWhere(
          (e) => e.apiValue == value,
      orElse: () => FitnessGoal.muscleGain,
    );
  }
}

enum WorkoutLevel {
  beginner,
  intermediate,
}

extension WorkoutLevelExtension on WorkoutLevel {
  String get apiValue {
    return name.toLowerCase();
  }

  String get displayName {
    switch (this) {
      case WorkoutLevel.beginner:
        return 'Beginner';
      case WorkoutLevel.intermediate:
        return 'Intermediate';
    }
  }

  static WorkoutLevel fromString(String value) {
    return WorkoutLevel.values.firstWhere(
          (e) => e.name == value,
      orElse: () => WorkoutLevel.beginner,
    );
  }
}

enum Gender { male, female }