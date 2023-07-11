class DateUtil {
  static int getMonthDays(DateTime date) {
    DateTime firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    DateTime firstDayNextMonth =
        new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);

    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
}
