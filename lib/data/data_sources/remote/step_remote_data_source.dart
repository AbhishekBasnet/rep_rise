import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/exception/api_exception.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/steps/daily_step_model.dart';
import 'package:rep_rise/data/model/steps/weekly_step_model.dart';

///
/// This class handles fetching aggregated step data (daily, weekly, monthly)
/// and syncing local step counts to the server via the provided [ApiClient].
class StepRemoteDataSource {
  final ApiClient apiClient;

  StepRemoteDataSource({required this.apiClient});

  /// Fetches step analytics for the current day.
  ///
  /// Returns a [DailyStepModel] containing the data for the current period.
  ///
  /// Throws an [ApiException] if the network request fails or the response
  /// cannot be parsed.
  Future<DailyStepModel> getDailySteps() async {
    try {
      final response = await apiClient.get('steps/analytics/', queryParameters: {'period': 'daily'});
      return DailyStepModel.fromJson(response.data);
    } catch (e) {
      throw ApiException(message: "Failed to fetch daily steps: $e");
    }
  }

  /// Retrieves a list of daily step data for the current week.
  ///
  /// Returns a [List] of [DailyStepModel] objects, where each object represents
  /// a specific day within the weekly period.
  ///
  /// Throws an [ApiException] if the fetch fails.
  Future<List<WeeklyStepModel>> getWeeklySteps() async {
    try {
      final response = await apiClient.get('steps/analytics/', queryParameters: {'period': 'weekly'});

      return (response.data as List).map((e) => WeeklyStepModel.fromJson(e)).toList();
    } catch (e) {
      throw ApiException(message: "Failed to fetch weekly steps: $e");
    }
  }
  Future<StepSummaryModel> getMonthlyStats(int year, int month) async {
    try {
      final response = await apiClient.get(
        'steps/analytics/',
        queryParameters: {'period': 'monthly', 'year': year, 'month': month},
      );
      return StepSummaryModel.fromJson(response.data);
    } catch (e) {
      throw ApiException(message: "Failed to fetch monthly stats: $e");
    }
  }

  /// Syncs local step count data to the remote server.
  ///
  /// * [stepCount]: The total number of steps to record.
  /// * [date]: The date string associated with the step count (e.g., ISO-8601).
  ///
  /// Throws an [ApiException] if the synchronization fails.
  Future<void> postSteps(int stepCount, String date) async {
    try {
      await apiClient.post('steps/', data: {'step_count': stepCount, 'date': date});
    } catch (e) {
      throw ApiException(message: "Failed to sync steps: $e");
    }
  }
}
