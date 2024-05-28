import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ynab_copilot/api/riverpods/notifiers/ynab_transactions_notifier.dart';
import 'package:ynab_copilot/api/riverpods/providers/category_provider.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/extensions/date_extensions.dart';
import 'package:ynab_copilot/extensions/ynab_extensions.dart';
import 'package:ynab_copilot/utils/chart_utils.dart';
import 'package:ynab_copilot/utils/number_utils.dart';
import 'package:ynab_copilot/utils/transaction_utils.dart';

class MonthlyBudgetedSpendingAnalytics extends HookConsumerWidget {
  MonthlyBudgetedSpendingAnalytics({required this.forMonth});

  final DateTime forMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    // final showTrendLine = useState(false);
    final budget = ref.watch(selectedYnabBudgetProvider);
    final transactionsState = ref.watch(ynabTransactionsControllerProvider(budgetId: budget?.id ?? ""));
    // final chartData = ref.watch(monthlyTransactionVolumeProvider(
    //   transactionsState.transactions,
    //   forMonth.value,
    // ));
    // final selectedChartIndex = useState(null as int?);
    // var listData = chartData.value ?? [];

    // // Calculate the maximum Y axis value and the interval.
    // // The max should be the highest value in the chart data + 100
    // double maxYAxis = 100;
    // double xInterval = 2;
    // double yInterval = maxYAxis / 10;
    // int startIdx = 0;
    // int endIdx = 0;
    // bool hasData = chartData.hasValue && chartData.value!.isNotEmpty;
    // if (hasData) {
    //   maxYAxis = (chartData.value!.map((e) => e.y).max + 100).round().toDouble();

    //   // Multiples of 100, 1000, 10000, etc., depending on the max value
    //   yInterval = pow(10, maxYAxis.toString().length - 4).toDouble();

    //   // If a data point is selected, show only that data point
    //   startIdx = selectedChartIndex.value ?? 0;
    //   endIdx = (selectedChartIndex.value != null) ? selectedChartIndex.value! + 1 : chartData.value!.length;
    //   listData = (chartData.value ?? []).sublist(startIdx, endIdx);

    //   // Scale the x axis based on the chartData length
    //   xInterval = (chartData.value!.length / 10).round().toDouble();
    // }

    final availableCategories = (categories.value ?? []).availableCategories;

    double totalBudgeted = amountToDollars(availableCategories.totalBudgeted);
    double totalActivity = amountToDollars(availableCategories.totalActivity);
    double totalBalance = amountToDollars(availableCategories.totalBalance);
    double moneyLeft = categories.hasValue ? totalBudgeted - totalActivity : 0;
    if (moneyLeft < 0) {
      moneyLeft = 0;
    }

    List<LineChartData> chartData = [];

    // Aggregate the spent amount for each day of the month if the transaction is in the current month
    final transactions =
        transactionsState.transactions.where((t) => t.date.isMatchingMonth(forMonth) && t.amount < 0).toList();
    final groupedTransactions = groupBy(transactions, (YnabTransaction t) => t.date.day);

    double totalSpent = 0;
    final now = DateTime.now().day;
    for (int i = 1; i <= forMonth.daysInMonth(); i++) {
      // Continue if the day is later than today
      if (i > now) continue;

      final dayTransactions = groupedTransactions[i] ?? [];
      // print(dayTransactions.length);
      final spent = amountToDollars(dayTransactions.fold(0, (prev, t) => prev + (t.amount * -1)));
      print("Day $i: $spent");
      chartData.add(LineChartData(i.toString(), totalSpent + spent, '', color: Colors.blue));
      totalSpent += spent;
    }

    print("CHART DATA: ${chartData.length}");

    print("Balance: $totalBalance");
    print("Total Spent: $totalSpent");
    print("Money Left: $moneyLeft");
    final List<LineChartData> balanceData = [
      LineChartData("1", 0, '', color: Colors.blue),
      LineChartData(forMonth.daysInMonth().toString(), totalBalance, formatMoney(totalBalance), color: Colors.blue),
    ];
    print(forMonth.daysInMonth().toString());

    print(balanceData);

    return SfCartesianChart(
        enableAxisAnimation: true,
        plotAreaBorderWidth: 0,
        // Show the month and year as the title
        title: ChartTitle(text: "${formatMoney(moneyLeft)} left", textStyle: TextStyle(fontSize: 14)),
        primaryXAxis: CategoryAxis(isVisible: true, interval: 1, maximum: forMonth.daysInMonth().toDouble()),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: totalBalance,
          interval: 100,
          isVisible: false,
        ),
        series: <CartesianSeries<LineChartData, String>>[
          SplineSeries<LineChartData, String>(
              // trendlines: (showTrendLine.value) ? [Trendline(type: TrendlineType.logarithmic)] : [],
              animationDuration: 500,
              dataSource: chartData,
              selectionBehavior: SelectionBehavior(enable: true),
              xValueMapper: (LineChartData data, _) => data.x,
              yValueMapper: (LineChartData data, _) => data.y,
              pointColorMapper: (LineChartData data, _) => data.color,
              onPointTap: (pointInteractionDetails) {
                // // Get the selected data point index
                // final int selectedDataPointIndex = pointInteractionDetails.pointIndex!;
                // selectedDataPointIndex == selectedChartIndex.value
                //     ? selectedChartIndex.value = null
                //     : selectedChartIndex.value = selectedDataPointIndex;
              },
              color: Color.fromRGBO(8, 142, 255, 1)),
          SplineSeries<LineChartData, String>(
              markerSettings: MarkerSettings(isVisible: true, height: 5, width: 5),
              // trendlines: (showTrendLine.value) ? [Trendline(type: TrendlineType.logarithmic)] : [],
              animationDuration: 500,
              dataSource: balanceData,
              // trendlines: [Trendline(type: TrendlineType.linear)],
              selectionBehavior: SelectionBehavior(enable: true),
              xValueMapper: (LineChartData data, _) => data.x,
              yValueMapper: (LineChartData data, _) => data.y,
              pointColorMapper: (LineChartData data, _) => data.color,
              // Only show the label on the last data point
              dataLabelMapper: (LineChartData data, index) => index == 1 ? data.label : '',
              dataLabelSettings: DataLabelSettings(isVisible: true),
              color: Colors.red)
        ]);
  }
}
