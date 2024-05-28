import 'dart:isolate';

import 'package:collection/collection.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/extensions/date_extensions.dart';
import 'package:ynab_copilot/utils/chart_utils.dart';
import 'package:ynab_copilot/utils/color_utils.dart';
import 'package:ynab_copilot/utils/transaction_utils.dart';

Future<void> loadMonthlyTransactionVolumeIsolate(List<dynamic> args) async {
  SendPort resultPort = args[0] as SendPort;
  List<YnabTransaction> transactions = args[1] as List<YnabTransaction>;
  DateTime forMonth = args[2] as DateTime;

  // transactions = transactions.where((element) => DateTime.parse(element.date).isMatchingMonth(forMonth)).toList();
  // final Map<String, List<YnabTransaction>> transactionsByDay =
  //     groupTransactionsByDay(transactions, DateTime(DateTime.now().year, DateTime.now().month));

  // Iterate over the transactions by day and add up the transactions
  final data = <VerticalBarChartData>[];
  // for (var entry in transactionsByDay.entries) {
  //   // Label is the total amounts of the transactions
  //   final double total = (entry.value).fold(0.0, (prev, transaction) {
  //     var amount = transaction.amount;

  //     // Check if there is a matching transaction that offsets this one.
  //     // The amount must be negative to be considered an offset, and the payee_name
  //     // must be the same.
  //     final match = entry.value.firstWhereOrNull((element) => element.amount == amount * -1);

  //     // We only want to count transactions that are negative and don't have a matching positive transaction
  //     if (match != null) {
  //       amount = 0;
  //     } else if (amount > 0) {
  //       amount = 0;
  //     }

  //     // Take the absolute value because the chart only shows positive amounts
  //     return prev + (amount / 1000).abs();
  //   });

  //   data.add(
  //       VerticalBarChartData(entry.key, total, '\$${total.toInt()}', entry.value, color: generateColor(entry.key)));
  // }

  // Set the data
  Isolate.exit(resultPort, data);
}

Future<List<VerticalBarChartData>> executeLoadMonthlyTransactionVolumeIsolate(
    List<YnabTransaction> transactions, DateTime month) async {
  // create the port to receive data from
  final resultPort = ReceivePort();
  // spawn a new isolate and pass down a function that will be used in a new isolate
  // and pass down the result port that will send back the result.
  // you can send any number of arguments.
  await Isolate.spawn(
    loadMonthlyTransactionVolumeIsolate,
    [resultPort.sendPort, transactions, month],
  );

  return await (resultPort.first) as List<VerticalBarChartData>;
}
