class DatePeopleTextUtil {
  DatePeopleTextUtil._();

  static String todayToTomorrow() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    return '${_formatMonthDay(today)} ~ ${_formatMonthDay(tomorrow)}';
  }

  static String range(DateTime start, DateTime end) {
    return '${_formatMonthDay(start)} ~ ${_formatMonthDay(end)}';
  }

  static String people(int count) {
    return '인원: $count명';
  }

  static String _formatMonthDay(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    return '$mm-$dd';
  }
}
