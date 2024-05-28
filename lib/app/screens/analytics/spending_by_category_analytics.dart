// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:ynab_copilot/database/models/ynab/transaction.dart';
// import 'package:ynab_copilot/utils/chart_utils.dart';
// import 'package:ynab_copilot/utils/color_utils.dart';
// import 'package:ynab_copilot/utils/transaction_utils.dart';

// class CategorySpend {
//   CategorySpend(this.category, this.amount, {this.hidden = false});

//   final String category;
//   final double amount;
//   bool hidden;
// }

// class SpendingByCategoryAnalytics extends StatefulWidget {
//   const SpendingByCategoryAnalytics({super.key, required this.transactions});

//   final List<YnabTransaction> transactions;

//   @override
//   State<SpendingByCategoryAnalytics> createState() => _SpendingByCategoryAnalyticsState();
// }

// class _SpendingByCategoryAnalyticsState extends State<SpendingByCategoryAnalytics> {
//   List<PieChartData> chartData = [];

//   Completer<void>? waitForData;

//   final List<int> _topValues = [5, 10, 15, 20, 25];

//   List<CategorySpend> spendingByCategory = [];

//   int _selectedValue = 0;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   void loadSpendingByCategory() {
//     final thisMonth = DateTime(DateTime.now().year, DateTime.now().month).subtract(Duration(milliseconds: 1));
//     final transactions =
//         widget.transactions.where((element) => DateTime.parse(element.date).isAfter(thisMonth)).toList();
//     final Map<String, dynamic> transactionsByCategory = groupTransactionsByCategory(transactions);

//     // Total spending by category
//     final Map<String, double> spendingByCategory = {};
//     transactionsByCategory.forEach((category, transactions) {
//       final double total = (transactions as List<dynamic>).fold(0.0, (prev, transaction) {
//         // We only care about the spending amount
//         var amount = transaction['amount'] as int;
//         if (amount > 0) {
//           amount = 0;
//         }

//         return prev + ((amount / 1000) * -1);
//       });

//       // Drop anything past the 2nd decimal
//       spendingByCategory[category] = double.parse(total.toStringAsFixed(2));
//     });

//     // Removes uncategorized category
//     spendingByCategory.remove('Uncategorized');

//     // Convert to CategorySpend objects
//     this.spendingByCategory = spendingByCategory.entries.map((entry) => CategorySpend(entry.key, entry.value)).toList();

//     // Sort spending categories by value
//     this.spendingByCategory.sort((e1, e2) => e2.amount.compareTo(e1.amount));
//   }

//   void buildChartData() {
//     // Filters out hidden categories and limits the number of categories to show
//     var subEntries = spendingByCategory.where((element) => !element.hidden && element.amount > 0.0).toList();
//     subEntries = subEntries.sublist(0, min(_topValues[_selectedValue], subEntries.length));

//     // Converts the map to a list of ChartData
//     chartData = subEntries
//         .map((entry) => PieChartData(entry.category, entry.amount,
//             '${entry.category}\n\$${entry.amount.toStringAsFixed(2)}', null, generateColor(entry.category)))
//         .toList();
//   }

//   void toggleHideCategory(String category) {
//     final index = spendingByCategory.indexWhere((element) => element.category == category);
//     if (index != -1) {
//       spendingByCategory[index].hidden = !spendingByCategory[index].hidden;
//     }

//     setState(() {
//       buildChartData();
//     });
//   }

//   Future<void> loadData() async {
//     setState(() {
//       waitForData = Completer<void>();
//     });

//     loadSpendingByCategory();
//     buildChartData();

//     setState(() {
//       waitForData!.complete();
//     });
//   }

//   void _showTopPicker(Widget child) {
//     showCupertinoModalPopup<void>(
//       context: context,
//       builder: (BuildContext context) => Container(
//         height: 215,
//         padding: const EdgeInsets.only(top: 6.0),
//         // The Bottom margin is provided to align the popup above the system navigation bar.
//         margin: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         // Provide a background color for the popup.
//         color: CupertinoColors.systemBackground.resolveFrom(context),
//         // Use a SafeArea widget to avoid system overlaps.
//         child: SafeArea(
//           top: false,
//           child: child,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       child: CustomScrollView(
//         slivers: <Widget>[
//           CupertinoSliverNavigationBar(
//             largeTitle: Row(children: [
//               Icon(CupertinoIcons.chart_pie),
//               Gap(5),
//               Text('Spending by Category', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
//             ]),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 Padding(
//                     padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//                     child: Wrap(alignment: WrapAlignment.start, spacing: 10, children: [
//                       Material(
//                           child: RawChip(
//                               avatar: Icon(CupertinoIcons.list_number, color: CupertinoColors.black.withAlpha(175)),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               side: BorderSide(color: CupertinoColors.systemBlue.withOpacity(0.5)),
//                               label: Text("Top ${_topValues[_selectedValue].toString()}",
//                                   style: TextStyle(color: CupertinoColors.black.withAlpha(175))),
//                               onPressed: () => _showTopPicker(
//                                     CupertinoPicker(
//                                       magnification: 1.22,
//                                       squeeze: 1.2,
//                                       useMagnifier: true,
//                                       itemExtent: 32.0,
//                                       // This sets the initial item.
//                                       scrollController: FixedExtentScrollController(
//                                         initialItem: 0,
//                                       ),
//                                       // This is called when selected item is changed.
//                                       onSelectedItemChanged: (int selectedItem) {
//                                         setState(() {
//                                           _selectedValue = selectedItem;
//                                           loadData();
//                                         });
//                                       },
//                                       children: List<Widget>.generate(_topValues.length, (int index) {
//                                         return Center(child: Text("Top ${_topValues[index].toString()}"));
//                                       }),
//                                     ),
//                                   ))),
//                     ])),
//                 Padding(
//                     padding: EdgeInsets.all(20),
//                     child: SfCircularChart(series: <CircularSeries>[
//                       // Render pie chart
//                       PieSeries<PieChartData, String>(
//                           animationDuration: 500,
//                           selectionBehavior: SelectionBehavior(enable: true),
//                           dataSource: chartData,
//                           pointColorMapper: (PieChartData data, _) => data.color,
//                           xValueMapper: (PieChartData data, _) => data.x,
//                           yValueMapper: (PieChartData data, _) => data.y,
//                           dataLabelMapper: (PieChartData data, _) => data.label,
//                           explode: true,
//                           radius: '75%',
//                           dataLabelSettings: DataLabelSettings(
//                             // Renders the data label
//                             isVisible: true,
//                             labelPosition: ChartDataLabelPosition.outside,
//                             textStyle: TextStyle(
//                               color: CupertinoColors.systemGrey.resolveFrom(context),
//                             ),
//                             labelIntersectAction: LabelIntersectAction.shift,
//                           ))
//                     ])),
//                 for (var category in spendingByCategory)
//                   Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: CupertinoListTile(
//                         title: Text(category.category),
//                         leading: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: generateColor(category.category),
//                           ),
//                           width: 18,
//                           height: 18,
//                         ),
//                         additionalInfo: Row(
//                           children: [
//                             Text("\$${category.amount.toStringAsFixed(2)}"),
//                           ],
//                         ),
//                         trailing: Icon((category.hidden) ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
//                             color: CupertinoColors.systemGrey),
//                         backgroundColor: (category.hidden ? CupertinoColors.systemGrey5 : null),
//                         onTap: () {
//                           print("HDIN");
//                           toggleHideCategory(category.category);
//                         },
//                       )),
//                 Gap(20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
