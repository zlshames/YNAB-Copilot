// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:gap/gap.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:ynab_copilot/database/models/ynab/transaction.dart';
// import 'package:ynab_copilot/utils/chart_utils.dart';
// import 'package:ynab_copilot/utils/transaction_utils.dart';

// class MonthlyTransactionVolumeAnalytics extends StatefulWidget {
//   const MonthlyTransactionVolumeAnalytics({super.key, required this.transactions});

//   final List<YnabTransaction> transactions;

//   @override
//   State<MonthlyTransactionVolumeAnalytics> createState() => _MonthlyTransactionVolumeAnalyticsState();
// }

// class _MonthlyTransactionVolumeAnalyticsState extends State<MonthlyTransactionVolumeAnalytics> {
//   List<VerticalBarChartData> chartData = [];
//   double maxYAxis = 40;

//   Completer<void>? waitForData;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   void loadMonthlyTransactionVolume() {
//     final thisMonth = DateTime(DateTime.now().year, DateTime.now().month).subtract(Duration(milliseconds: 1));
//     final transactions =
//         widget.transactions.where((element) => DateTime.parse(element.date).isAfter(thisMonth)).toList();
//     final Map<String, List<dynamic>> transactionsByDay =
//         groupTransactionsByDay(transactions, DateTime(DateTime.now().year, DateTime.now().month));

//     // Iterate over the transactions by day and count the number of transactions
//     final data = <VerticalBarChartData>[];
//     for (var entry in transactionsByDay.entries) {
//       // Label is the total amounts of the transactions
//       final double totalAmount =
//           entry.value.fold(0, (previousValue, element) => previousValue + (((element['amount'] as int) / 1000) * -1));
//       data.add(VerticalBarChartData(entry.key, entry.value.length.toDouble(), '\$${totalAmount.toInt()}', []));
//     }

//     // Get the maximum value for the Y axis
//     int max = 0;
//     for (var entry in transactionsByDay.entries) {
//       if (entry.value.length > max) {
//         max = entry.value.length;
//       }
//     }

//     maxYAxis = max.toDouble() + 2;

//     // Set the data
//     chartData = data;
//   }

//   Future<void> loadData() async {
//     setState(() {
//       waitForData = Completer<void>();
//     });

//     loadMonthlyTransactionVolume();

//     setState(() {
//       waitForData!.complete();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       child: CustomScrollView(
//         slivers: <Widget>[
//           CupertinoSliverNavigationBar(
//             largeTitle: Row(children: [
//               Icon(CupertinoIcons.chart_bar),
//               Gap(5),
//               Text('Monthly Transaction Volume', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
//             ]),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 Padding(
//                     padding: EdgeInsets.all(20),
//                     child: SfCartesianChart(
//                         // Show the month and year as the title
//                         title: ChartTitle(
//                             text: DateFormat('MMMM yyyy').format(DateTime(DateTime.now().year, DateTime.now().month)),
//                             textStyle: TextStyle(fontSize: 18)),
//                         primaryXAxis: CategoryAxis(
//                           title: AxisTitle(text: 'Day of the Month'),
//                           interval: 2,
//                         ),
//                         primaryYAxis: NumericAxis(
//                             title: AxisTitle(text: 'Number of Transactions'),
//                             minimum: 0,
//                             maximum: maxYAxis,
//                             interval: 1),
//                         series: <CartesianSeries<VerticalBarChartData, String>>[
//                           ColumnSeries<VerticalBarChartData, String>(
//                               trendlines: [Trendline(type: TrendlineType.logarithmic)],
//                               animationDuration: 500,
//                               dataSource: chartData,
//                               selectionBehavior: SelectionBehavior(enable: true),
//                               xValueMapper: (VerticalBarChartData data, _) => data.x,
//                               yValueMapper: (VerticalBarChartData data, _) => data.y,
//                               color: Color.fromRGBO(8, 142, 255, 1))
//                         ])),
//                 // for (var category in spendingByCategory)
//                 //   Padding(
//                 //       padding: EdgeInsets.symmetric(horizontal: 10),
//                 //       child: CupertinoListTile(
//                 //         title: Text(category.category),
//                 //         leading: Container(
//                 //           decoration: BoxDecoration(
//                 //             shape: BoxShape.circle,
//                 //             color: generateColor(category.category),
//                 //           ),
//                 //           width: 18,
//                 //           height: 18,
//                 //         ),
//                 //         additionalInfo: Row(
//                 //           children: [
//                 //             Text("\$${category.amount.toStringAsFixed(2)}"),
//                 //           ],
//                 //         ),
//                 //         trailing: Icon((category.hidden) ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
//                 //             color: CupertinoColors.systemGrey),
//                 //         backgroundColor: (category.hidden ? CupertinoColors.systemGrey5 : null),
//                 //         onTap: () {
//                 //           print("HDIN");
//                 //           toggleHideCategory(category.category);
//                 //         },
//                 //       )),
//                 Gap(20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
