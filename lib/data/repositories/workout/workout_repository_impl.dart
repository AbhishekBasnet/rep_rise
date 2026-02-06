import 'package:rep_rise/data/data_sources/remote/workout_remote_data_source.dart';
import 'package:rep_rise/data/model/workout_model/workout_model.dart';
import 'package:rep_rise/domain/entity/workout/workout_entity.dart';
import 'package:rep_rise/domain/repositories/workout/workout_repository.dart';

class WorkoutRepositoryImpl extends WorkoutRepository {
  final WorkoutRemoteDataSource remoteDataSource;

  WorkoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WorkoutEntity> getWorkout() async {
    try {
      final WorkoutModel workout = await remoteDataSource.getWorkout();
      return workout.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
