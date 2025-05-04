// core/utils/date_helper.dart
class DateHelper {
  static String toIso8601String(DateTime date) {
    return date.toIso8601String();
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatForDisplay(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
