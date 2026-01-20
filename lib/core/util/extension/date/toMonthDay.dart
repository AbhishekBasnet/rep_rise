import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  /// Returns string in format: "January 20
  String get toMonthDay {
    // 'MMMM' gives full month name, 'd' gives day number
    return DateFormat('MMMM d').format(this);
  }
}