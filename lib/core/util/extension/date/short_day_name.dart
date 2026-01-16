extension DayNameExtractor on DateTime {
  String get toShortDayName {
    const List<String> days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    return days[this.weekday - 1];
  }
}