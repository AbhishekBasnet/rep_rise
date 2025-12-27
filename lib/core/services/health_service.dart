import 'package:health/health.dart';

class HealthService {
  // Use the new singleton constructor
  final Health health = Health();

  Future<List<HealthDataPoint>> getStepHistory(DateTime start, DateTime end) async {
    // 1.configure the plugin
    await health.configure();

    var types = [HealthDataType.STEPS];

    // 2. Request Authorization
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      // 3. Fetch data
      return await health.getHealthDataFromTypes(
          types: types,
          startTime: start,
          endTime: end
      );
    } else {
      throw Exception("Permission denied");
    }
  }
}