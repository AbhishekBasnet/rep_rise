import 'package:rep_rise/core/exception/api_exception.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/steps/step_model.dart';
import 'package:intl/intl.dart';

class StepRemoteDataSource {
  final ApiClient client;

  StepRemoteDataSource({required this.client});

  Future<StepModel> getDailySteps() async {
    try {
      final response = await client.get('steps/analytics/', queryParameters: {'period': 'daily'});
      return StepModel.fromJson(response.data);
    } catch (e) {
      throw ApiException(message: "Failed to fetch daily steps: $e");
    }
  }

  Future<List<StepModel>> getWeeklySteps() async {
    try {
      final response = await client.get('steps/analytics/', queryParameters: {'period': 'weekly'});

      return (response.data as List).map((e) => StepModel.fromJson(e)).toList();
    } catch (e) {
      throw ApiException(message: "Failed to fetch weekly steps: $e");
    }
  }

  Future<StepSummaryModel> getMonthlyStats(int year, int month) async {
    try {
      final response = await client.get(
        'steps/analytics/',
        queryParameters: {'period': 'monthly', 'year': year, 'month': month},
      );
      return StepSummaryModel.fromJson(response.data);
    } catch (e) {
      throw ApiException(message: "Failed to fetch monthly stats: $e");
    }
  }

  Future<void> postSteps(int stepCount, DateTime date) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      await client.post('steps/', data: {'step_count': stepCount, 'date': dateString});
    } catch (e) {
      throw ApiException(message: "Failed to sync steps: $e");
    }
  }
}
