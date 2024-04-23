import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ynab_copilot/utils/chart_utils.dart';
import 'package:ynab_copilot/utils/data_utils.dart';

class SpendingByCategoryAnalytics extends StatefulWidget {
  const SpendingByCategoryAnalytics({super.key, required this.transactions, required this.categories});

  final List<dynamic> transactions;
  final List<dynamic> categories;

  @override
  State<SpendingByCategoryAnalytics> createState() => _SpendingByCategoryAnalyticsState();
}

class _SpendingByCategoryAnalyticsState extends State<SpendingByCategoryAnalytics> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();

    final thisMonth = DateTime(DateTime.now().year, DateTime.now().month);
    final transactions =
        widget.transactions.where((element) => DateTime.parse(element['date'] as String).isAfter(thisMonth)).toList();
    final Map<String, dynamic> transactionsByCategory = groupTransactionsByCategory(transactions);

    // Total spending by category
    final Map<String, double> spendingByCategory = {};
    transactionsByCategory.forEach((category, transactions) {
      final total = transactions.fold(0.0, (prev, transaction) => prev + transaction['amount'] as double);
      spendingByCategory[category] = total as double;
    });

    print(spendingByCategory);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Row(children: [
              Icon(CupertinoIcons.chart_pie),
              Gap(5),
              Text('Spending by Category', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
            ]),
          ),
          SliverFillRemaining(
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SfCircularChart(series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartData, String>(
                      dataSource: chartData,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelMapper: (ChartData data, _) => data.label,
                      explode: true,
                      radius: '50%',
                      dataLabelSettings: DataLabelSettings(
                        // Renders the data label
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: TextStyle(
                          color: CupertinoColors.systemGrey.resolveFrom(context),
                        ),
                        labelIntersectAction: LabelIntersectAction.none,
                      ))
                ])
              ],
            )),
          ),
        ],
      ),
    );
  }
}
