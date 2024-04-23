import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:ynab_copilot/app/screens/analytics_selection_screen.dart';
import 'package:ynab_copilot/globals.dart';
import 'package:ynab_copilot/utils/color_utils.dart';
import 'package:ynab_copilot/utils/date_utils.dart';

class BudgetSelectorScreen extends StatefulWidget {
  @override
  State<BudgetSelectorScreen> createState() => _BudgetSelectorScreenState();
}

class _BudgetSelectorScreenState extends State<BudgetSelectorScreen> {
  List<dynamic> budgets = [];

  @override
  void initState() {
    super.initState();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    final budgets = await ynab.getBudgets();
    setState(() {
      this.budgets = budgets['data']['budgets'] as List<dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // A ScrollView that creates custom scroll effects using slivers.
      child: CustomScrollView(
        // A list of sliver widgets.
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Row(children: [
              Image.asset('assets/ynab_logo.png', width: 30),
              Gap(5),
              Text('Budgets', style: TextStyle(fontWeight: FontWeight.w500))
            ]),
          ),
          // This widget fills the remaining space in the viewport.
          // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
          SliverFillRemaining(
              child: CupertinoListSection(
            footer: const Text('Select a budget to analyze spending habits.'),
            children: <CupertinoListTile>[
              if (budgets.isEmpty)
                const CupertinoListTile(
                  title: Text('No budgets found!'),
                ),
              for (var budget in budgets)
                CupertinoListTile(
                  title: Text(budget['name'] as String),
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: generateColor(budget['id'] as String),
                    ),
                    width: 18,
                    height: 18,
                  ),
                  additionalInfo: Row(
                    children: [
                      Icon(CupertinoIcons.timer, size: 16, color: CupertinoColors.systemGrey),
                      Gap(5),
                      Text(relativeDate(DateTime.parse(budget['last_modified_on'] as String))),
                    ],
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    // Navigate to the budget detail screen.
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) => AnalyticsSelectionScreen(budgetInfo: budget),
                      ),
                    );
                  },
                ),
            ],
          )),
        ],
      ),
    );
  }
}
