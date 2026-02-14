import 'package:flutter/foundation.dart';
import 'package:rep_rise/core/util/extension/date/short_day_name.dart';
import 'package:rep_rise/core/util/extension/to_precision.dart';
import 'package:rep_rise/domain/entity/steps/daily_step_entity.dart';
import 'package:rep_rise/domain/entity/steps/weekly_step_entity.dart';
import 'package:rep_rise/domain/usecase/step/get_daily_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_monthly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_weekly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/sync_step_usecase.dart';
import 'package:rep_rise/presentation/provider/step/WeekelyChartData.dart';

/*
 * Manages the state and business logic integration for the Step Tracking feature.
 *
 * Architecture & Responsibilities:
 * --------------------------------
 * This provider acts as the Presentation Layer controller, orchestrating data flow
 * between the UI and the Domain Layer UseCases. It is responsible for:
 *
 * 1. Initialization Sequence:
 * Upon instantiation, `initSteps` executes a sequential data load:
 * - Synchronization: Triggers `syncStepsUseCase` to align local/remote dat.
 * - Daily Fetch: Retrieves current day statistics via `getDailyStepUsecase`.
 * - Weekly Aggregation: Compiles historical data via `getWeeklyStepUsecase`.
 *
 * 2. Data Aggregation & Stitching:
 * A key responsibility of this provider is the 'stitching' logic within `fetchWeeklySteps`.
 * Since the weekly history UseCase returns past data, this provider manually injects
 * the live `_walkedDailySteps` (from memory) into the dataset to ensure the
 * UI reflects real-time updates without re-fetching history unnecessarily.
 *
 * 3. View Model Transformation:
 * - Converts Domain Entities (`StepEntity`) into UI-specific models (`WeeklyChartData`).
 * - Normalizes data for visualization (e.g., mapping DateTime weekdays to x-axis indices).
 * - Calculates UI metadata, such as `_highestWeeklyGoal` for dynamic chart scaling.
 *
 * State Management:
 * -----------------
 * Uses `ChangeNotifier` to broadcast updates. The `_isLoading` flag serves as a
 * synchronization primitive to prevent UI jitter during the multi-step fetch process.
 */

class StepProvider extends ChangeNotifier {
  final GetDailyStepUsecase getDailyStepUsecase;
  final GetWeeklyStepUsecase getWeeklyStepUsecase;
  final GetMonthlyStepUsecase getMonthlyStepUsecase;
  final SyncStepsUseCase syncStepsUseCase;

  StepProvider({
    required this.getDailyStepUsecase,
    required this.getWeeklyStepUsecase,
    required this.getMonthlyStepUsecase,
    required this.syncStepsUseCase,
  });

  int _dailyStepGoal = 0;
  int _walkedDailySteps = 0;
  double _percentage = 1;
  bool _isLoading = false;
  int _highestWeeklyGoal = 10000;

  double _caloriesBurned = 0;
  double _distanceMeters = 0;
  int _durationMinutes = 0;
  List<WeeklyChartData> _weeklyChartData = [];

  List<WeeklyChartData> get weeklyChartData => _weeklyChartData;
  bool get isLoading => _isLoading;
  double get percentage => _percentage;
  int get dailyStepGoal => _dailyStepGoal;
  int get walkedDailySteps => _walkedDailySteps;
  int get highestWeeklyGoal => _highestWeeklyGoal;
  double get caloriesBurned => _caloriesBurned;
  double get distanceKiloMeters => (_distanceMeters / 1000).toPrecision(2);
  int get durationMinutes => _durationMinutes;

  void clearData() {
    _dailyStepGoal = 0;
    _walkedDailySteps = 0;
    _percentage = 0;
    _caloriesBurned = 0;
    _distanceMeters = 0;
    _durationMinutes = 0;
    _weeklyChartData = [];
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initSteps() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('🔄 [StepProvider] initSteps: Starting synchronization...');
      await syncStepsUseCase.execute();
      debugPrint('✅ [StepProvider] initSteps: Sync complete.');

      await fetchDailySteps();
      await fetchWeeklySteps();
    } catch (e) {
      debugPrint("❌ [StepProvider] Error during step initialization: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailySteps() async {
    // We don't set isLoading=true here if called from initSteps to avoid flickering,
    // but if called alone it might be useful. Kept logic simple.

    try {
      debugPrint("📡 [StepProvider] fetchDailySteps: Requesting data...");

      // Removed artificial delay unless absolutely necessary for animation smoothness
      // await Future.delayed(const Duration(seconds: 1));

      final DailyStepEntity stepData = await getDailyStepUsecase.execute();

      // --- DEBUG LOGS START ---
      debugPrint("\n*********************************************");
      debugPrint("🔍 [StepProvider] RAW SERVER RESPONSE (Daily):");
      debugPrint("   ➡️ Steps: ${stepData.steps}");
      debugPrint("   ➡️ Goal: ${stepData.goal}  <-- CHECK THIS VALUE");
      debugPrint("   ➡️ Calories: ${stepData.caloriesBurned}");
      debugPrint("   ➡️ Distance: ${stepData.distanceMeters}");
      debugPrint("*********************************************\n");
      // --- DEBUG LOGS END ---

      _walkedDailySteps = stepData.steps;
      _dailyStepGoal = stepData.goal;
      _percentage = stepData.progressPercentage;
      _caloriesBurned = stepData.caloriesBurned;
      _distanceMeters = stepData.distanceMeters;
      _durationMinutes = stepData.durationMinutes;

      notifyListeners();
    } catch (e) {
      debugPrint("❌ [StepProvider] Error fetching daily steps: $e");
    }
  }

  Future<void> fetchWeeklySteps() async {
    try {
      debugPrint("📡 [StepProvider] fetchWeeklySteps: Requesting history...");
      final history = await getWeeklyStepUsecase.execute();

      // --- DEBUG LOGS START ---
      debugPrint("🔍 [StepProvider] RAW SERVER RESPONSE (Weekly History - ${history.length} items):");
      if (history.isEmpty) {
        debugPrint("   ⚠️ History list is EMPTY");
      } else {
        for (var item in history) {
          debugPrint("   📅 Date: ${item.date.toShortDayName} | Steps: ${item.steps} | Goal: ${item.goal}");
        }
      }
      // --- DEBUG LOGS END ---

      final String todayStr = DateTime.now().toShortDayName;

      // Stitching current local data into the history
      final todayEntity = WeeklyStepEntity(
        date: DateTime.now(),
        steps: _walkedDailySteps,
        goal: _dailyStepGoal,
        dayName: todayStr,
      );

      final fullWeekEntities = [...history, todayEntity];

      int maxVal = 0;
      for (var entity in fullWeekEntities) {
        if (entity.goal > maxVal) maxVal = entity.goal;
        if (entity.steps > maxVal) maxVal = entity.steps;
      }

      // Round up to nearest 1000 for chart Y-axis beauty
      final int roundedMaxGoal = (maxVal == 0) ? 10000 : (maxVal / 1000).ceil() * 1000;
      _highestWeeklyGoal = roundedMaxGoal;

      debugPrint("📊 [StepProvider] Chart Scaling - Highest Goal Calculated: $_highestWeeklyGoal");

      _weeklyChartData = fullWeekEntities.map((e) {
        return WeeklyChartData(
          xIndex: e.date.weekday % 7,
          steps: e.steps.toDouble(),
          isToday: e.date.toShortDayName == todayStr,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("❌ [StepProvider] Error processing weekly steps: $e");
    }
  }
}
