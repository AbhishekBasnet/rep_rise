import 'package:flutter/foundation.dart';
import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/usecase/step/get_daily_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_monthly_step_usecase.dart';
import 'package:rep_rise/domain/usecase/step/get_weekly_step_usecase.dart';

class StepProvider extends ChangeNotifier {
  //use cases
  final GetDailyStepUsecase getDailyStepUsecase;
  final GetWeeklyStepUsecase getWeeklyStepUsecase;
  final GetMonthlyStepUsecase getMonthlyStepUsecase;

  StepProvider({
    required this.getDailyStepUsecase,
    required this.getWeeklyStepUsecase,
    required this.getMonthlyStepUsecase,
  }){
    fetchDailySteps();
  }
  //variables
  int _totalDailySteps = 0;
  int _walkedDailySteps = 0;
  double _percentage = 1;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double get percentage => _percentage;
  int get totalDailySteps => _totalDailySteps;
  int get walkedDailySteps => _walkedDailySteps;

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
}
