import 'package:jwt_decoder/jwt_decoder.dart';

extension TokenHelpers on String {
  /// Returns the Duration until (or since) the token expires.
  /// If positive: time remaining. If negative: time since expired.
  Duration get remainingTime {
    final expirationDate = JwtDecoder.getExpirationDate(this);
    return expirationDate.difference(DateTime.now());
  }

  /// Returns a human-readable string for debugging.
  /// Shows "Xm Ys remaining" or "Expired Xm Ys ago".
  String get expirationStatus {
    final remaining = remainingTime;

    // Calculate absolute values so the math works for both past and future
    final minutes = remaining.inMinutes.abs();
    final seconds = (remaining.inSeconds % 60).abs();

    if (remaining.isNegative) {
      return "Expired $minutes m $seconds s ago";
    }

    if (remaining == Duration.zero) return "Expired just now";

    return "$minutes m $seconds s remaining";
  }
}