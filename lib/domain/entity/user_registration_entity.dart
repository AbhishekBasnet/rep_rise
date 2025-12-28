class UserRegistrationEntity {
  final String username;
  final String email;
  final String password;
  final double height;
  final double weight;
  final DateTime birthDate;
  final double activityLevel;
  final String fitnessGoal;

  UserRegistrationEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.height,
    required this.weight,
    required this.birthDate,
    required this.activityLevel,
    required this.fitnessGoal,
  });
}