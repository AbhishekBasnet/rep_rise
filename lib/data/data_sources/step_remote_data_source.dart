import 'package:rep_rise/core/network/api_client.dart';
import 'package:rep_rise/data/model/step_model.dart';

class StepRemoteDataSource {
  final ApiClient apiClient;
  StepRemoteDataSource({required this.apiClient});
  Future<void> postSteps(StepModel stepModel) async {
    try{
      await apiClient.dio.post(
        '/steps/update',
        data: stepModel.toJson(),
      );
    } catch (e) {
      throw Exception("   Failed ti sync steps to backend: $e");
    }
  }
}