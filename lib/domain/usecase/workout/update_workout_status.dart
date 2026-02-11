import 'package:rep_rise/domain/entity/workout/workout_entity.dart';
import 'package:rep_rise/domain/repositories/workout/workout_repository.dart';

class UpdateWorkoutStatus {
  final WorkoutRepository workoutRepository;

  UpdateWorkoutStatus({required this.workoutRepository});

  Future<WorkoutEntity> call(String dayName, bool isDone) async {
    return await workoutRepository.updateWorkoutProgress(dayName, isDone);
  }
}
