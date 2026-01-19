
import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';

abstract class StepRepository {
  Future<StepEntity> getDailySteps();

  Future<List<StepEntity>> getWeeklySteps();

  Future<StepSummaryEntity> getMonthlyStats(int year, int month);

  Future<void> syncSteps();

  Future<void> clearLocalCache();
}
