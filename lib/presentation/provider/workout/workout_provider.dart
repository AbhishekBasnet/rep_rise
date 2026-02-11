import 'package:flutter/material.dart';
import 'package:rep_rise/domain/entity/workout/workout_entity.dart';
import 'package:rep_rise/domain/usecase/workout/get_workout_usecase.dart';
import 'package:rep_rise/domain/usecase/workout/update_workout_status.dart';

class WorkoutProvider extends ChangeNotifier {
  final GetWorkoutUseCase getWorkoutUseCase;
  final UpdateWorkoutStatus updateWorkoutStatus;
  WorkoutProvider({required this.getWorkoutUseCase, required this.updateWorkoutStatus});

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
      debugPrint("🏋️ FETCHED PROGRESS FROM JSON: ${_workoutEntity?.progress}");
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDayProgress(String dayName, bool currentStatus) async {
    final bool isDoneTarget = !currentStatus;

    try {
      final updatedWorkout = await updateWorkoutStatus.call(dayName, isDoneTarget);
      debugPrint("🏋️ UPDATED PROGRESS MAP: ${_workoutEntity?.progress}");
      _workoutEntity = updatedWorkout;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to update progress: ${e.toString()}";
    } finally {
      notifyListeners();
    }
  }

  bool isDayCompleted(String dayName) {
    if (_workoutEntity == null) return false;

    final isDone = _workoutEntity!.progress[dayName] ?? false;

    debugPrint("🏋️ CHECKING UI FOR: '$dayName' | FOUND IN MAP: $isDone");

    return isDone;
  }
}
