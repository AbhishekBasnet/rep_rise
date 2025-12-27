
import '../../core/services/health_steps_service.dart';
import '../../domain/entity/step_entity.dart';
import '../../domain/repositories/step_repository.dart';
import '../data_sources/step_remote_data_source.dart';
import '../model/step_model.dart';



class StepRepositoryImpl implements StepRepository {
  final HealthService _healthService;
  final StepRemoteDataSource remoteDataSource;

  StepRepositoryImpl({
    required HealthService healthService,
    required this.remoteDataSource
  }): _healthService = healthService;

  DateTime now = DateTime.now();
  late String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  @override
  Future<void> syncSteps() async {
    // service handle the hardware/plugin logic
    final int totalStepsToday = await _healthService.getTotalStepsToday();
    final model = StepModel(
      date: formattedDate,
      stepCount: totalStepsToday,
    );

    // Let the data source handle the network logic
    // Use 'postSteps' to match your file
    await remoteDataSource.postSteps(model);
  }

  @override
  Future<List<StepEntity>> getStepHistory(String period) {
    // TODO: implement getStepHistory
    throw UnimplementedError();
  }



}

