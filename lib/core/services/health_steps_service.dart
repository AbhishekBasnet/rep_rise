import 'package:health/health.dart';

class HealthService {
  final Health health = Health();

  Future<int> getTotalStepsToday() async {
    await health.configure();
    var types = [HealthDataType.STEPS];
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      // specific method for total steps in an interval
      int? steps = await health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } else {
      throw Exception("Permission denied");
    }
  }
}
