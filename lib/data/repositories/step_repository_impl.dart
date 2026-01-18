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

  @override
  Future<List<StepEntity>> getWeeklySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDate = DateTime.now().toDateOnly.toString();
    final String? lastFetchDate = prefs.getString('last_weekly_fetch_date');

    // 1. OPTIMIZATION: Check if we already have fresh data
    // If we fetched today, we skip the API and go straight to DB
    if (lastFetchDate == todayDate) {
      debugPrint("    STEP REPO: Optimization active. Fetching from Drift DB.");

      return _fetchFromLocalDb();
    }

    // 2. ONLINE: If cache is stale, try fetching from API
    try {
      final List<StepModel> stepModels = await remoteDataSource.getWeeklySteps();

      await stepLocalDataSource.cacheSteps(stepModels);

      await prefs.setString('last_weekly_fetch_date', todayDate);

      // Return the fresh data directly
      return stepModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      debugPrint("    STEP REPO: API Failed ($e). Falling back to local data.");
      // 3. FALLBACK: If API fails, return whatever we have in DB
      return _fetchFromLocalDb();
    }
  }

  Future<List<StepEntity>> _fetchFromLocalDb() async {
    final localData = await stepLocalDataSource.getCachedSteps();

    // "today" is 00:00:00.000 of the current day
    // we want data from the last 7 days excluding today, the provider adds today's live data separately
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

  @override
  Future<void> syncSteps() async {
    final int deviceSteps = await healthService.getTotalStepsToday();
    final now = DateTime.now();
    final DateTime cleanDate = DateTime(now.year, now.month, now.day);
    final String apiDateString = cleanDate.toIso8601String().split('T')[0];

    await remoteDataSource.postSteps(deviceSteps, apiDateString);
    debugPrint("    Synced $deviceSteps steps for date $apiDateString to remote server.");

    //----------- get latest goal from local cache -----------
    // Get all history
    final history = await stepLocalDataSource.getCachedSteps();
    final validGoals = history.where((element) => element.goal > 0).toList();

    int inheritedGoal;

    if (validGoals.isNotEmpty) {
      // ✅ OLD USER: Inherit their last goal
      validGoals.sort((a, b) => b.date.compareTo(a.date));
      inheritedGoal = validGoals.first.goal;
    } else {
      // ✅ NEW USER: Default fallback (since DB is empty)
      inheritedGoal = 5000; // Or whatever default you prefer
    }

    // 3. Cache locally
    final localEntry = StepModel(
      date: cleanDate,
      dayName: now.toShortDayName,
      steps: deviceSteps,
      goal: inheritedGoal,
    );
    await stepLocalDataSource.cacheSteps([localEntry]);
  }
}
