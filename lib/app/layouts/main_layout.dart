import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:ynab_copilot/api/riverpods/notifiers/ynab_transactions_notifier.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/app/screens/analytics/monthly_spending_volume_analytics.dart';
import 'package:ynab_copilot/app/widgets/loader.dart';

class MainLayout extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(selectedYnabBudgetProvider);
    final transactionController = ref.watch(ynabTransactionsControllerProvider(budgetId: budget?.id ?? ""));

    return CupertinoPageScaffold(
      // A ScrollView that creates custom scroll effects using slivers.
      child: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
              largeTitle: Row(children: [
            Icon(Icons.analytics),
            Gap(5),
            Text('Analytics', style: TextStyle(fontWeight: FontWeight.w500))
          ])),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
              child: (transactionController.isLoading)
                  ? Center(child: Loader(text: 'Loading Transactions...'))
                  : Animate(
                      effects: [FadeEffect()],
                      child: CupertinoListSection(
                          footer:
                              const Text('Choose an analytics option to take a deep dive into your spending habits.'),
                          children: <CupertinoListTile>[
                            // CupertinoListTile(
                            //   padding: const EdgeInsets.all(20),
                            //   title: const Text("Spending by Category"),
                            //   subtitle: const Text("Pie chart breakdown of spending by category."),
                            //   leading: Icon(CupertinoIcons.chart_pie, size: 24),
                            //   trailing: const CupertinoListTileChevron(),
                            //   onTap: () {
                            //     // Navigate to the budget detail screen.
                            //     Navigator.of(context).push(
                            //       SwipeablePageRoute<void>(
                            //         builder: (BuildContext context) => SpendingByCategoryAnalytics(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            // CupertinoListTile(
                            //   padding: const EdgeInsets.all(20),
                            //   title: const Text("Monthly Transaction Volume"),
                            //   subtitle: const Text("Bar chart showing volume of transactions during the month"),
                            //   leading: Icon(CupertinoIcons.chart_bar, size: 24),
                            //   trailing: const CupertinoListTileChevron(),
                            //   onTap: () {
                            //     // Navigate to the budget detail screen.
                            //     Navigator.of(context).push(
                            //       SwipeablePageRoute<void>(
                            //         builder: (BuildContext context) => MonthlyTransactionVolumeAnalytics(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            CupertinoListTile(
                              padding: const EdgeInsets.all(20),
                              title: const Text("Monthly Spending Volume"),
                              subtitle: const Text("Bar chart showing volume of spending during the month"),
                              leading: Icon(CupertinoIcons.chart_bar_alt_fill, size: 24),
                              trailing: const CupertinoListTileChevron(),
                              onTap: () {
                                // Navigate to the budget detail screen.
                                Navigator.of(context).push(
                                  SwipeablePageRoute<void>(
                                    builder: (BuildContext context) => MonthlySpendingVolumeAnalytics(),
                                  ),
                                );
                              },
                            ),
                          ]))),
        ],
      ),
    );
  }
}
