import 'package:health/health.dart';

/// A facade service for interacting with platform-specific health stores
/// (Apple HealthKit on iOS, Health Connect/Google Fit on Android).
///
/// This service handles:
/// * Configuration of the underlying [Health] factory.
/// * Requesting necessary user permissions for health data types.
/// * Aggregating raw health data into consumable statistics (e.g., daily steps).
class HealthService {
  final Health health = Health();

  /// Fetches the aggregated total step count for the current day.
  ///
  /// This method requests [HealthDataType.STEPS] permissions if not already granted.
  ///
  /// Returns:
  /// A [Future] containing the total steps from midnight (00:00) to the current time.
  /// Returns `0` if no data is found for the interval.
  ///
  /// Throws:
  /// * [Exception] if the user denies health data permissions.
  Future<int> getTotalStepsToday() async {
    await health.configure();
    var types = [HealthDataType.STEPS];
    bool requested = await health.requestAuthorization(types);

    if (requested) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      // Fetch and aggregate steps.
      // Note: We use 'getTotalStepsInInterval' rather than fetching raw data points
      // to let the native platform handle the complexity of merging conflicting data sources.
      int? steps = await health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } else {
      throw Exception("Permission denied");
    }
  }
}
