import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/workout/workout_entity.dart';
import 'package:rep_rise/domain/usecase/workout/get_workout_usecase.dart';

class WorkoutProvider extends ChangeNotifier {
  final GetWorkoutUseCase getWorkoutUseCase;
  WorkoutProvider({required this.getWorkoutUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  WorkoutEntity? _workoutEntity;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  WorkoutEntity? get workoutEntity => _workoutEntity;

  Future<void> fetchWorkout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _workoutEntity = await getWorkoutUseCase.call();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
