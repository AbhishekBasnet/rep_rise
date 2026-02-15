import 'package:rep_rise/domain/entity/profile/register_user_profile_data_entity.dart';

class RegisterUserProfileModel extends RegisterUserProfileEntity {
  RegisterUserProfileModel({
    required super.age,
    required super.weight,
    required super.height,
    required super.stepGoal,
    required super.gender,
    required super.targetWeight,
    required super.fitnessLevel,
  });

  factory RegisterUserProfileModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserProfileModel(
      age: json['age'],

      weight: (json['weight'] as num).toInt(),
      height: (json['height'] as num).toInt(),

      stepGoal: json['daily_step_goal'],

      gender: json['gender'],
      targetWeight: (json['target_weight'] as num).toInt(),
      fitnessLevel: json['fitness_level'],
    );
  }

  factory RegisterUserProfileModel.fromEntity(RegisterUserProfileEntity entity) {
    return RegisterUserProfileModel(
      age: entity.age,
      weight: entity.weight,
      height: entity.height,
      stepGoal: entity.stepGoal,
      gender: entity.gender,
      targetWeight: entity.targetWeight,
      fitnessLevel: entity.fitnessLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "weight": weight,
      "height": height,
      "daily_step_goal": stepGoal,
      "gender": gender,
      "target_weight": targetWeight,
    };
  }
}
