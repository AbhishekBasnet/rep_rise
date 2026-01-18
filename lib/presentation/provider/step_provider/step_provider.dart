import 'package:flutter/foundation.dart';
import 'package:rep_rise/core/util/extension/date/short_day_name.dart';
import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/usecase/step/get_daily_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_monthly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_weekly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/sync_step_usecase.dart';
import 'package:rep_rise/presentation/provider/step_provider/WeekelyChartData.dart';


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
  int _highestWeeklyGoal =10000 ;
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
      // 1. Get History (e.g., Sun, Mon)
      final history = await getWeeklyStepUsecase.execute();

      final String todayStr = DateTime.now().toShortDayName;
      // 2. Get Live Today
      final todayEntity = StepEntity(
        date: DateTime.now(),
        steps: _walkedDailySteps,
        goal: _totalDailySteps,
        dayName: todayStr,
      );

      // 3. Stitch Step Entities together
      final fullWeekEntities = [...history, todayEntity];
      debugPrint('   on Step provider: Full week entities: \n$fullWeekEntities');

      //max steps in the week for highestWeeklyGoal
      int maxGoal = 0;
      for(var entity in fullWeekEntities){
        if(entity.goal > maxGoal){
          maxGoal = entity.goal;
        }
      }
      _highestWeeklyGoal = maxGoal;
      // debugPrint('   on Step provider: Highest weekly goal: $_highestWeeklyGoal and calculated maxGoal: $maxGoal');

      // 4. TRANSFORM LOGIC (Entity -> View Model)
      // This is the logic we moved out of the UI!

      _weeklyChartData = fullWeekEntities.map((e) {
        return WeeklyChartData(
          // Logic: Convert DateTime weekday (1=Mon...7=Sun) to Chart Index (0=Sun...6=Sat)
          xIndex: e.date.weekday % 7,

          // Logic: Convert to double for the library
          steps: e.steps.toDouble(),

          // Logic: Determine highlight status
          isToday: e.date.toShortDayName == todayStr,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("   on Step provider: Error processing weekly steps: $e");
    }
  }
}
