import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/extensions/date_extensions.dart';

Map<String, List<YnabTransaction>> groupTransactionsByCategory(List<YnabTransaction> transactions) {
  final Map<String, List<YnabTransaction>> groupedTransactions = {};

  // for (final transaction in transactions) {
  //   final category = transaction.categoryName;
  //   if (groupedTransactions.containsKey(category)) {
  //     groupedTransactions[category]!.add(transaction);
  //   } else if (category == 'Split') {
  //     for (final st in transaction.subtransactions) {
  //       final subTransaction = YnabTransaction.fromSubtransaction(st);
  //       final subCategory = subTransaction.categoryName;
  //       if (groupedTransactions.containsKey(subCategory)) {
  //         groupedTransactions[subCategory]!.add(subTransaction);
  //       } else {
  //         groupedTransactions[subCategory] = [subTransaction];
  //       }
  //     }
  //   } else {
  //     groupedTransactions[category] = [transaction];
  //   }
  // }

  return groupedTransactions;
}

Map<String, List<YnabTransaction>> groupTransactionsByDay(List<YnabTransaction> transactions, DateTime date,
    {bool includeAllDays = true, bool fillCurrentMonth = false}) {
  final Map<String, List<YnabTransaction>> groupedTransactions = {};

  if (includeAllDays) {
    final thisMonth = DateTime(DateTime.now().year, DateTime.now().month);

    // Get total days in the current month.
    // Add 1 to the month and subtract 1 day to get the last day of the current month.
    int daysInMonth = DateTime(date.year, date.month + 1, 0).subtract(Duration(days: 1)).day;

    // If it's the current month, and we don't want to fill the current month, then only show the days up to today.
    if (date.isMatchingMonth(thisMonth) && !fillCurrentMonth) {
      daysInMonth = DateTime.now().day;
    }

    for (var i = 1; i <= daysInMonth; i++) {
      groupedTransactions['$i'] = [];
    }
  }

  // for (final transaction in transactions) {
  //   final day = DateTime.parse(transaction.date).day.toString();
  //   if (groupedTransactions.containsKey(day)) {
  //     groupedTransactions[day]!.add(transaction);
  //   } else {
  //     groupedTransactions[day] = [transaction];
  //   }
  // }

  return groupedTransactions;
}

double amountToDollars(int amount) {
  return amount / 1000;
}
