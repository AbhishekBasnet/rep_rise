import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/workout/workout_model.dart';

class WorkoutRemoteDataSource {
  final ApiClient apiClient;

  WorkoutRemoteDataSource({required this.apiClient});

  Future<WorkoutModel> getWorkout() async {
    try {
      final response = await apiClient.get('ai/recommendation/');
      if (response.statusCode == 200) {
        return WorkoutModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load recommendations: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<WorkoutModel> updateWorkoutProgress(String dayName, bool isDone) async {
    try {
      final response = await apiClient.patch(
        'ai/recommendation/complete/',
        data: {"day_name": dayName, "is_done": isDone},
      );

      if (response.statusCode == 200) {
        return WorkoutModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update progress: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
