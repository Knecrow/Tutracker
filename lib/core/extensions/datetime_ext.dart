import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Returns ISO 8601 string (with UTC offset)
  String toISO() => toIso8601String();

  /// True if this date is the same calendar day as [other]
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// ISO week number (1–53)
  int get weekNumber {
    final dayOfYear = int.parse(DateFormat('D').format(this));
    return ((dayOfYear - weekday + 10) / 7).floor();
  }

  /// Returns month label like "Jan 2025"
  String get monthLabel => DateFormat('MMM yyyy').format(this);

  /// Returns short day label like "Mon"
  String get shortDay => DateFormat('EEE').format(this);

  /// Returns day number as string like "12"
  String get dayLabel => DateFormat('d').format(this);

  /// Returns formatted time like "4:30 PM"
  String get timeLabel => DateFormat('h:mm a').format(this);

  /// Midnight of this date (used for day comparisons)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Last moment of this date
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// First day of this month
  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  /// Last day of this month
  DateTime get lastDayOfMonth => DateTime(year, month + 1, 0);

  /// Number of days in this month
  int get daysInMonth => lastDayOfMonth.day;
}

extension StringDateExtensions on String {
  /// Parse ISO 8601 string to DateTime
  DateTime toDateTime() => DateTime.parse(this);
}
