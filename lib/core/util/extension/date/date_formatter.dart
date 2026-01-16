extension DateOnlyCompare on DateTime {
  // Returns a new DateTime with time set to 00:00:00
  DateTime get toDateOnly {
    return DateTime(this.year, this.month, this.day);
  }
}