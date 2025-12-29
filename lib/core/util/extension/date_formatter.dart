extension DateTimeFormatting on DateTime {
  /// Converts DateTime to "YYYY-MM-DD" string for backend compatibility.
  /// Example: 1995-05-20
  String toBackendFormat() {
    return "${year.toString().padLeft(4, '0')}-"
        "${month.toString().padLeft(2, '0')}-"
        "${day.toString().padLeft(2, '0')}";
  }
}