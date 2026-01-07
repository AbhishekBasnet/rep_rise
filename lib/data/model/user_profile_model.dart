import 'package:rep_rise/domain/entity/user_profile_data_entity.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    required super.age,
    required super.weight,
    required super.height,
    required super.stepGoal,
    required super.gender,
    required super.bmi,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      age: json['age'],

      weight: (json['weight'] as num).toInt(),
      height: (json['height'] as num).toInt(),

      stepGoal: json['daily_step_goal'],

      gender: json['gender'],
      bmi: json['bmi'],
    );
  }

  factory UserProfileModel.fromEntity(UserProfileEntity entity) {
    return UserProfileModel(
      age: entity.age,
      weight: entity.weight,
      height: entity.height,
      stepGoal: entity.stepGoal,
      gender: entity.gender,
      bmi: entity.bmi,
    );
  }

  Map<String, dynamic> toJson() {
    return {"age": age, "weight": weight, "height": height, "daily_step_goal": stepGoal, "gender": gender};
  }
}
