import 'package:rep_rise/domain/repositories/workout/workout_repository.dart';

import '../../entity/workout/workout_entity.dart';

class GetWorkoutUseCase {
  final WorkoutRepository workoutRepository;

  GetWorkoutUseCase({required this.workoutRepository });

  Future<WorkoutEntity> call() async {
    return await workoutRepository.getWorkout();
  }
}
