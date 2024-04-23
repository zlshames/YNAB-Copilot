import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ynab_copilot/app/screens/analytics/spending_by_category_analytics.dart';
import 'package:ynab_copilot/app/widgets/widgets.dart';
import 'package:ynab_copilot/globals.dart';

class AnalyticsSelectionScreen extends StatefulWidget {
  AnalyticsSelectionScreen({super.key, required this.budgetInfo});

  final dynamic budgetInfo;

  @override
  State<AnalyticsSelectionScreen> createState() => _AnalyticsSelectionScreenState();
}

class _AnalyticsSelectionScreenState extends State<AnalyticsSelectionScreen> {
  Completer<void>? waitForData;
  List<dynamic> transactions = [];
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      waitForData = Completer<void>();
    });

    try {
      // Load data here
      final transactions = await ynab.getBudgetTransactions(widget.budgetInfo['id'] as String);
      final categories = await ynab.getBudgetCategories(widget.budgetInfo['id'] as String);
      setState(() {
        this.transactions = transactions['data']['transactions'] as List<dynamic>;
        this.categories = categories['data']['categories'] as List<dynamic>;
      });
    } catch (e) {
      // Handle error
    }

    setState(() {
      waitForData!.complete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingData = !(waitForData?.isCompleted ?? true);
    print(waitForData?.isCompleted);
    return CupertinoPageScaffold(
      // A ScrollView that creates custom scroll effects using slivers.
      child: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
              largeTitle: Row(children: [
                Icon(Icons.analytics),
                Gap(5),
                Text('Budgets', style: TextStyle(fontWeight: FontWeight.w500))
              ]),
              trailing: IconButton(
                icon: Icon(Icons.refresh, size: 28, color: (isLoadingData) ? Colors.grey : Colors.blue),
                onPressed: () {
                  if (isLoadingData) return;
                  loadData();
                },
              )),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
              child: FutureBuilder<void>(
                  future: waitForData?.future ?? Future.value(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return genericLoader;
                    } else {
                      return CupertinoListSection(
                          footer:
                              const Text('Choose an analytics option to take a deep dive into your spending habits.'),
                          children: <CupertinoListTile>[
                            CupertinoListTile(
                              padding: const EdgeInsets.all(20),
                              title: const Text("Spending by Category"),
                              subtitle: const Text("Pie chart breakdown of spending by category."),
                              leading: Icon(CupertinoIcons.chart_pie, size: 24),
                              trailing: const CupertinoListTileChevron(),
                              onTap: () {
                                // Navigate to the budget detail screen.
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        SpendingByCategoryAnalytics(transactions: transactions, categories: categories),
                                  ),
                                );
                              },
                            ),
                            CupertinoListTile(
                              padding: const EdgeInsets.all(20),
                              title: const Text("Monthly Transaction Volume"),
                              subtitle: const Text("Bar chart showing volume of transactions during the month"),
                              leading: Icon(CupertinoIcons.chart_bar, size: 24),
                              trailing: const CupertinoListTileChevron(),
                              onTap: () {
                                // Navigate to the budget detail screen.
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (BuildContext context) => Container(),
                                  ),
                                );
                              },
                            ),
                            CupertinoListTile(
                              padding: const EdgeInsets.all(20),
                              title: const Text("Monthly Spending Volume"),
                              subtitle: const Text("Bar chart showing volume of spending during the month"),
                              leading: Icon(CupertinoIcons.chart_bar_alt_fill, size: 24),
                              trailing: const CupertinoListTileChevron(),
                              onTap: () {
                                // Navigate to the budget detail screen.
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (BuildContext context) => Container(),
                                  ),
                                );
                              },
                            ),
                          ]);
                    }
                  }))
        ],
      ),
    );
  }
}
