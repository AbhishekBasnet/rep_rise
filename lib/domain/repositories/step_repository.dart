
import 'package:rep_rise/domain/entity/steps/daily_step_entity.dart';
import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';
import 'package:rep_rise/domain/entity/steps/weekly_step_entity.dart';

abstract class StepRepository {
  Future<DailyStepEntity> getDailySteps();

  Future<List<WeeklyStepEntity>> getWeeklySteps();

  Future<StepSummaryEntity> getMonthlyStats(int year, int month);

  Future<void> syncSteps();

  Future<void> clearLocalCache();
}
