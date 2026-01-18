import 'package:flutter/foundation.dart';
import 'package:rep_rise/core/util/extension/date/short_day_name.dart';
import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/usecase/step/get_daily_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_monthly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_weekly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/sync_step_usecase.dart';
import 'package:rep_rise/presentation/provider/step_provider/WeekelyChartData.dart';

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
  }) {
    initSteps();
  }

  int _totalDailySteps = 0;
  int _walkedDailySteps = 0;
  double _percentage = 1;
  bool _isLoading = false;
  int _highestWeeklyGoal = 10000;
  List<WeeklyChartData> _weeklyChartData = [];

  List<WeeklyChartData> get weeklyChartData => _weeklyChartData;
  bool get isLoading => _isLoading;
  double get percentage => _percentage;
  int get totalDailySteps => _totalDailySteps;
  int get walkedDailySteps => _walkedDailySteps;
  int get highestWeeklyGoal => _highestWeeklyGoal;

  Future<void> initSteps() async {
    _isLoading = true;
    notifyListeners();

    try {
      await syncStepsUseCase.execute();

      await fetchDailySteps();

      await fetchWeeklySteps();
    } catch (e) {
      debugPrint("Error during step initialization: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDailySteps() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      final StepEntity stepData = await getDailyStepUsecase.execute();
      debugPrint(
        "Fetched daily steps: ${stepData.steps}, Goal: ${stepData.goal}, Percentage: ${stepData.progressPercentage}",
      );
      _walkedDailySteps = stepData.steps;
      _totalDailySteps = stepData.goal;
      _percentage = stepData.progressPercentage;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeeklySteps() async {
    try {
      final history = await getWeeklyStepUsecase.execute();

      final String todayStr = DateTime.now().toShortDayName;
      final todayEntity = StepEntity(
        date: DateTime.now(),
        steps: _walkedDailySteps,
        goal: _totalDailySteps,
        dayName: todayStr,
      );

      final fullWeekEntities = [...history, todayEntity];
      debugPrint('   on Step provider: Full week entities: \n$fullWeekEntities');

      int maxGoal = 0;
      for (var entity in fullWeekEntities) {
        if (entity.goal > maxGoal) {
          maxGoal = entity.goal;
        }
      }
      _highestWeeklyGoal = maxGoal;

      _weeklyChartData = fullWeekEntities.map((e) {
        return WeeklyChartData(
          xIndex: e.date.weekday % 7,

          steps: e.steps.toDouble(),

          isToday: e.date.toShortDayName == todayStr,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("   on Step provider: Error processing weekly steps: $e");
    }
  }
}
