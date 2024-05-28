extension DateTimeExtension on DateTime {
  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  bool isBetween(
    DateTime fromDateTime,
    DateTime toDateTime,
  ) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }

  bool isMatchingMonth(DateTime dateTime) {
    final date = this;
    print(
        "Comparing ${date.year}/${date.month} to ${dateTime.year}/${dateTime.month} & -> ${date.year == dateTime.year && date.month == dateTime.month}");
    return date.year == dateTime.year && date.month == dateTime.month;
  }

  int daysInMonth() {
    final date = this;
    return DateTime(date.year, date.month + 1).subtract(Duration(minutes: 1)).day;
  }
}
