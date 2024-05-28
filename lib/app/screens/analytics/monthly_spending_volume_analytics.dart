import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ynab_copilot/api/riverpods/notifiers/ynab_transactions_notifier.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/app/screens/selectors/monthly_analytics_filters.dart';
import 'package:ynab_copilot/app/screens/views/transactions_list.dart';
import 'package:ynab_copilot/app/widgets/loader.dart';
import 'package:ynab_copilot/utils/chart_utils.dart';
import 'package:ynab_copilot/utils/color_utils.dart';
import 'package:ynab_copilot/utils/date_utils.dart';
import 'package:ynab_copilot/utils/number_utils.dart';
import 'package:ynab_copilot/utils/ui_utils.dart';

class MonthlySpendingVolumeAnalytics extends HookConsumerWidget {
  final dateFilterOpts =
      getMonthsSince(DateTime.now(), maxMonths: 12).map((e) => DateFormat('MMMM yyyy').format(e)).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forMonth = useState(DateTime(DateTime.now().year, DateTime.now().month));
    final showTrendLine = useState(false);
    final budget = ref.watch(selectedYnabBudgetProvider);
    final transactionsState = ref.watch(ynabTransactionsControllerProvider(budgetId: budget?.id ?? ""));
    final chartData = ref.watch(monthlyTransactionVolumeProvider(
      transactionsState.transactions,
      forMonth.value,
    ));
    final selectedChartIndex = useState(null as int?);
    var listData = chartData.value ?? [];

    // Calculate the maximum Y axis value and the interval.
    // The max should be the highest value in the chart data + 100
    double maxYAxis = 100;
    double xInterval = 2;
    double yInterval = maxYAxis / 10;
    int startIdx = 0;
    int endIdx = 0;
    bool hasData = chartData.hasValue && chartData.value!.isNotEmpty;
    if (hasData) {
      maxYAxis = (chartData.value!.map((e) => e.y).max + 100).round().toDouble();

      // Multiples of 100, 1000, 10000, etc., depending on the max value
      yInterval = pow(10, maxYAxis.toString().length - 4).toDouble();

      // If a data point is selected, show only that data point
      startIdx = selectedChartIndex.value ?? 0;
      endIdx = (selectedChartIndex.value != null) ? selectedChartIndex.value! + 1 : chartData.value!.length;
      listData = (chartData.value ?? []).sublist(startIdx, endIdx);

      // Scale the x axis based on the chartData length
      xInterval = (chartData.value!.length / 10).round().toDouble();
    }

    Widget body = Center(child: Loader(text: "${selectRandomLoadingPhrase()}..."));
    if (transactionsState.didError) {
      body = Center(child: Text(transactionsState.error.toString()));
    } else if (hasData) {
      body = Column(children: [
        SfCartesianChart(
            enableAxisAnimation: true,
            // Show the month and year as the title
            title: ChartTitle(text: DateFormat('MMMM yyyy').format(forMonth.value), textStyle: TextStyle(fontSize: 18)),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: 'Day of the Month'),
              interval: xInterval,
            ),
            primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Total Spending Amount'), minimum: 0, maximum: maxYAxis, interval: yInterval),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
              enableSelectionZooming: true,
            ),
            series: <CartesianSeries<VerticalBarChartData, String>>[
              ColumnSeries<VerticalBarChartData, String>(
                  markerSettings:
                      MarkerSettings(isVisible: true, height: 5, width: 5, shape: DataMarkerType.horizontalLine),
                  trendlines: (showTrendLine.value) ? [Trendline(type: TrendlineType.logarithmic)] : [],
                  animationDuration: 500,
                  dataSource: chartData.value!,
                  selectionBehavior: SelectionBehavior(enable: true),
                  xValueMapper: (VerticalBarChartData data, _) => data.x,
                  yValueMapper: (VerticalBarChartData data, _) => data.y,
                  pointColorMapper: (VerticalBarChartData data, _) => data.color,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  onPointTap: (pointInteractionDetails) {
                    // Get the selected data point index
                    final int selectedDataPointIndex = pointInteractionDetails.pointIndex!;
                    selectedDataPointIndex == selectedChartIndex.value
                        ? selectedChartIndex.value = null
                        : selectedChartIndex.value = selectedDataPointIndex;
                  },
                  color: Color.fromRGBO(8, 142, 255, 1)),
            ]),
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              for (VerticalBarChartData category in listData)
                CupertinoListTile(
                    title: Text(
                        "${DateFormat('MMMM').format(forMonth.value.add(Duration(days: int.parse(category.x))))} ${category.x}${getDayOfMonthSuffix(int.parse(category.x))}"),
                    leading: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: generateColor(category.x),
                      ),
                      width: 18,
                      height: 18,
                    ),
                    additionalInfo: Row(
                      children: [
                        Text(formatMoney(category.y, currencyFormat: budget!.currencyFormat!)),
                      ],
                    ),
                    trailing: CupertinoListTileChevron(),
                    onTap: () => showCupertinoModalPopup<DateTime>(
                        context: context,
                        builder: (BuildContext context) {
                          return TransactionsList(
                              transactions: selectedChartIndex.value != null
                                  ? chartData.value![selectedChartIndex.value!].transactions
                                  : category.transactions);
                        })).animate().fadeIn().moveY(begin: 25, end: 0, duration: 200.ms, curve: Curves.easeIn)
            ]),
          ),
        ),
      ]);
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Row(children: [
            Icon(CupertinoIcons.chart_bar_alt_fill),
            Gap(5),
            Text('Monthly Spending Volume', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
          ]),
          trailing: IconButton(
              icon: Icon(
                Icons.tune,
                size: 24,
              ),
              onPressed: () async {
                final MonthlyFilters? filters = await showCupertinoModalPopup<MonthlyFilters>(
                    context: context,
                    builder: (BuildContext context) {
                      return MonthlyAnalyticsFilters(
                          initialMonthSelection: forMonth.value, initialShowTrendLine: showTrendLine.value);
                    });

                if (filters != null) {
                  forMonth.value = filters.forMonth ?? forMonth.value;
                  showTrendLine.value = filters.showTrendLine ?? showTrendLine.value;
                }
              }),
        ),
        child: Padding(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Animate(effects: [FadeEffect()], child: body)));
  }
}
