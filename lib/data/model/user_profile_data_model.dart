import 'package:rep_rise/domain/entity/user_profile_data_entity.dart';

class UserProfileDataModel extends UserProfileDataEntity {
  UserProfileDataModel({
    required super.age,
    required super.weight,
    required super.height,
    required super.stepGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "weight": weight,
      "height": height,
      "stepGoal": stepGoal,
    };
  }
}