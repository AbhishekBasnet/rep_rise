

import 'package:rep_rise/core/services/health_steps_service.dart';
import 'package:rep_rise/data/data_sources/step_remote_data_source.dart';
import 'package:rep_rise/data/model/steps/step_model.dart';
import 'package:rep_rise/domain/entity/steps/step_entity.dart';
import 'package:rep_rise/domain/entity/steps/step_summary_entity.dart';
import 'package:rep_rise/domain/repositories/step_repository.dart';

class StepRepositoryImpl implements StepRepository {
  final StepRemoteDataSource remoteDataSource;
  final HealthService healthService;

  StepRepositoryImpl({required this.remoteDataSource, required this.healthService});

  @override
  Future<StepEntity> getDailySteps() async {
    final StepModel stepModel = await remoteDataSource.getDailySteps();
    return stepModel.toEntity();
  }

  @override
  Future<List<StepEntity>> getWeeklySteps() async {
    final List<StepModel> stepModel = await remoteDataSource.getWeeklySteps();
    return stepModel.map((model) => model.toEntity()).toList();
  }

  @override
  Future<StepSummaryEntity> getMonthlyStats(int year, int month) async {
    final model = await remoteDataSource.getMonthlyStats(year, month);
    return model;
  }

  @override
  Future<void> syncSteps() async {
    final int deviceSteps = await healthService.getTotalStepsToday();
    await remoteDataSource.postSteps(deviceSteps, DateTime.now());
  }
}