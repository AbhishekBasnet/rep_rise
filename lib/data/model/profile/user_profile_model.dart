import '../../../domain/entity/profile/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.username,
    required super.email,
    required super.height,
    required super.weight,
    required super.age,
    required super.gender,
    required super.dailyStepGoal,
    required super.bmi,
    required super.fitnessGoal,
    required super.fitnessLevel,
    required super.split,
    required super.targetWeight,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'] as Map<String, dynamic>;

    return UserProfileModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',

      height: (profileData['height'] as num).toDouble(),
      weight: (profileData['weight'] as num).toDouble(),
      age: (profileData['age'] as num).toInt(),
      gender: profileData['gender'] ?? 'unknown',
      dailyStepGoal: (profileData['daily_step_goal'] as num).toInt(),
      bmi: (profileData['bmi'] as num).toDouble(),
      fitnessGoal: profileData['goal'] ?? 'unknown',
      fitnessLevel: profileData['level'] ?? 'unknown',
      split: profileData['level'] ?? 'unknown',
      targetWeight: (profileData['target_weight'] as num?)?.toDouble() ?? 0.0,
    );
  }

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      username: username,
      email: email,
      height: height,
      weight: weight,
      age: age,
      gender: gender,
      dailyStepGoal: dailyStepGoal,
      bmi: bmi,
      fitnessGoal: fitnessGoal,
      fitnessLevel: fitnessLevel,
      split: split,
      targetWeight: targetWeight,
    );
  }
}
