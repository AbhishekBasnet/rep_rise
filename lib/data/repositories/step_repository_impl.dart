import 'package:flutter/foundation.dart';
import 'package:rep_rise/core/services/health_steps_service.dart';
import 'package:rep_rise/core/util/extension/date/date_formatter.dart';
import 'package:rep_rise/core/util/extension/date/short_day_name.dart';
import 'package:rep_rise/data/data_sources/local/step/step_local_data_source.dart';
import 'package:rep_rise/data/data_sources/remote/step_remote_data_source.dart';
import 'package:rep_rise/data/model/steps/step_model.dart';
import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * ARCHITECTURE OVERVIEW: StepRepository implementation.
 *
 * This repository serves as the Single Source of Truth (SSOT) for step data, mediating
 * between three distinct data sources:
 * 1. Remote API: The authoritative backend source for historical data and analytics.
 * 2. Local Database (Drift): A persistent cache used to enable offline capabilities
 * and reduce network load.
 * 3. Health Service: The device-level sensor interface for real-time step counting.
 *
 * Data Strategy:
 * - Read Operations: utilize a "Stale-While-Revalidate" or "Cache-First" approach
 * depending on the freshness of the data (tracked via SharedPreferences).
 * - Write Operations (Sync): Aggregates real-time device data, pushes it to the
 * Remote API, and simultaneously updates the Local Database to ensure UI consistency
 * without requiring a subsequent refetch.
 */

class StepRepositoryImpl implements StepRepository {
  final StepLocalDataSource stepLocalDataSource;
  final StepRemoteDataSource remoteDataSource;
  final HealthService healthService;

  StepRepositoryImpl({required this.remoteDataSource, required this.healthService, required this.stepLocalDataSource});

  @override
  Future<StepEntity> getDailySteps() async {
    try {
      final StepModel stepModel = await remoteDataSource.getDailySteps();

      return stepModel.toEntity();
    } catch (e) {
      return StepEntity(date: DateTime.now().toDateOnly, steps: 0, goal: 0, dayName: DateTime.now().toShortDayName);
    }
  }

  /*
    Implements a caching strategy using [SharedPreferences] to track fetch frequency.
  1. If data for the current day has already been fetched, returns cached data directly.
  2. If data is stale, fetches from [remoteDataSource], updates the cache, and returns fresh data.
  3. If the network request fails, falls back to the local database to preserve user experience.
  */
  @override
  Future<List<StepEntity>> getWeeklySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDate = DateTime.now().toDateOnly.toString();
    final String? lastFetchDate = prefs.getString('last_weekly_fetch_date');

    if (lastFetchDate == todayDate) {
      debugPrint("    STEP REPO: Optimization active. Fetching from Drift DB.");

      return _fetchFromLocalDb();
    }

    try {
      final List<StepModel> stepModels = await remoteDataSource.getWeeklySteps();

      await stepLocalDataSource.cacheSteps(stepModels);

      await prefs.setString('last_weekly_fetch_date', todayDate);

      return stepModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      debugPrint("    STEP REPO: API Failed ($e). Falling back to local data.");
      return _fetchFromLocalDb();
    }
  }

  Future<List<StepEntity>> _fetchFromLocalDb() async {
    final localData = await stepLocalDataSource.getCachedSteps();

    final DateTime today = DateTime.now().toDateOnly;
    final DateTime sevenDaysAgo = today.subtract(const Duration(days: 6));
    final weeklyData = localData.where((step) {
      return !step.date.isBefore(sevenDaysAgo) && step.date.isBefore(today);
    }).toList();

    weeklyData.sort((a, b) => a.date.compareTo(b.date));

    return weeklyData.map((c) => StepEntity(date: c.date, steps: c.steps, goal: c.goal, dayName: c.dayName)).toList();
  }

  @override
  Future<StepSummaryEntity> getMonthlyStats(int year, int month) async {
    final StepSummaryModel stepSummaryModel = await remoteDataSource.getMonthlyStats(year, month);
    return stepSummaryModel.toEntity();
  }

  /// Synchronizes the current device step count with the remote server and local cache.
  ///
  /// This process involves:
  /// 1. Reading the raw step count from [HealthService].
  /// 2. Uploading the count to the [remoteDataSource].
  /// 3. Calculating the current step goal based on historical user behavior.
  /// 4. Updating the [stepLocalDataSource] to reflect the sync immediately.

  @override
  Future<void> syncSteps() async {
    final int deviceSteps = await healthService.getTotalStepsToday();
    final now = DateTime.now();
    final DateTime cleanDate = DateTime(now.year, now.month, now.day);
    final String apiDateString = cleanDate.toIso8601String().split('T')[0];

    await remoteDataSource.postSteps(deviceSteps, apiDateString);
    debugPrint("    Synced $deviceSteps steps for date $apiDateString to remote server.");

    final history = await stepLocalDataSource.getCachedSteps();
    final validGoals = history.where((element) => element.goal > 0).toList();

    int inheritedGoal;

    if (validGoals.isNotEmpty) {
      validGoals.sort((a, b) => b.date.compareTo(a.date));
      inheritedGoal = validGoals.first.goal;
    } else {
      inheritedGoal = 5000;
    }

    final localEntry = StepModel(date: cleanDate, dayName: now.toShortDayName, steps: deviceSteps, goal: inheritedGoal);
    await stepLocalDataSource.cacheSteps([localEntry]);
  }

  @override
  Future<void> clearLocalCache() async {
    await stepLocalDataSource.deleteAllSteps();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_weekly_fetch_date');

    debugPrint("    STEP REPO: Local cache & preferences cleared.");
  }
}
