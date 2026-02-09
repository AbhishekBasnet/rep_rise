
import '../../entity/workout/workout_entity.dart';

abstract class WorkoutRepository {
  Future<WorkoutEntity> getWorkout();
}