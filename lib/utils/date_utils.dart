import 'package:ynab_copilot/extensions/date_extensions.dart';

/// Converts a DateTime object to a relative date string
String relativeDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return '${difference.inSeconds}s ago';
  }
}

List<DateTime> getMonthsSince(DateTime before, {DateTime? after, int? maxMonths}) {
  final now = DateTime.now();
  final months = <DateTime>[];

  // Make sure the before date is after the after date (assert)
  assert(after == null || before.isAfter(after), 'The before date must be after the after date');

  // Require either an after date or a max number of months
  assert(after != null || maxMonths != null, 'Either an after date or a max number of months must be provided');

  while (before.isBeforeOrEqualTo(now)) {
    months.add(DateTime(before.year, before.month));
    before = DateTime(before.year, before.month - 1);

    if (after != null && before.isBefore(after)) {
      break;
    } else if (maxMonths != null && months.length >= maxMonths) {
      break;
    }
  }

  return months;
}

String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
