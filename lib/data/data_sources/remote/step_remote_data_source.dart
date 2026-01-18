import 'package:flutter/cupertino.dart';
import 'package:rep_rise/core/exception/api_exception.dart';
import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/steps/step_model.dart';

///
/// This class handles fetching aggregated step data (daily, weekly, monthly)
/// and syncing local step counts to the server via the provided [ApiClient].
class StepRemoteDataSource {
  final ApiClient client;

  StepRemoteDataSource({required this.client});

  /// Fetches step analytics for the current day.
  ///
  /// Returns a [StepModel] containing the data for the current period.
  ///
  /// Throws an [ApiException] if the network request fails or the response
  /// cannot be parsed.
  Future<StepModel> getDailySteps() async {
    try {
      final response = await client.get('steps/analytics/', queryParameters: {'period': 'daily'});
      return StepModel.fromJson(response.data);
    } catch (e) {
      throw ApiException(message: "Failed to fetch daily steps: $e");
    }
  }

  /// Retrieves a list of daily step data for the current week.
  ///
  /// Returns a [List] of [StepModel] objects, where each object represents
  /// a specific day within the weekly period.
  ///
  /// Throws an [ApiException] if the fetch fails.
  Future<List<StepModel>> getWeeklySteps() async {
    try {
      final response = await client.get('steps/analytics/', queryParameters: {'period': 'weekly'});

      return (response.data as List).map((e) => StepModel.fromJson(e)).toList();
    } catch (e) {
      throw ApiException(message: "Failed to fetch weekly steps: $e");
    }
  }

  /// Retrieves a summary of step statistics for a specific month.
  ///
  /// * [year]: The target year (e.g., 2024).
  /// * [month]: The target month (1-12).
  ///
  /// Returns a [StepSummaryModel] aggregating the month's activity.
  ///
  /// Throws an [ApiException] if the request fails.
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

  /// Syncs local step count data to the remote server.
  ///
  /// * [stepCount]: The total number of steps to record.
  /// * [date]: The date string associated with the step count (e.g., ISO-8601).
  ///
  /// Throws an [ApiException] if the synchronization fails.
  Future<void> postSteps(int stepCount, String date) async {
    try {
      await client.post('steps/', data: {'step_count': stepCount, 'date': date});
    } catch (e) {
      throw ApiException(message: "Failed to sync steps: $e");
    }
  }
}
