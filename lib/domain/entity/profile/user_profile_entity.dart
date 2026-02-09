import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String username;
  final String email;
  final double height;
  final double weight;
  final int age;
  final String gender;
  final int dailyStepGoal;
  final double bmi;
  final String fitnessGoal;
  final String fitnessLevel;
  final String split;
  final double targetWeight;

  const UserProfileEntity({
    required this.username,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.dailyStepGoal,
    required this.bmi,
    required this.fitnessGoal,
    required this.fitnessLevel,
    required this.split,
    required this.targetWeight,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    height,
    weight,
    age,
    gender,
    dailyStepGoal,
    bmi,
    fitnessGoal,
    fitnessLevel,
    split,
    targetWeight,
  ];
}
