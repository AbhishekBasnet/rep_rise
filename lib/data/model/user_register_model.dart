import '../../domain/entity/user_registration_entity.dart';

class RegisterModel extends UserRegistrationEntity {
  RegisterModel({
    required super.username,
    required super.email,
    required super.password,
    required super.height,
    required super.weight,
    required super.birthDate,
    required super.activityLevel,
    required super.fitnessGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "email": email,
      "profile": {
        "height": height,
        "weight": weight,
        "birth_date": birthDate,
        "activity_level": activityLevel,
        "fitness_goal": fitnessGoal,
      }
    };
  }
}