import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/database/models/ynab/budget.dart';
import 'package:ynab_copilot/app/screens/budget_categories_view.dart';
import 'package:ynab_copilot/utils/color_utils.dart';
import 'package:ynab_copilot/utils/date_utils.dart';

class BudgetSelectorScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(ynabBudgetsProvider);
    return CupertinoPageScaffold(
      child: CustomScrollView(
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
              if ((budgets.value ?? []).isEmpty)
                const CupertinoListTile(
                  title: Text('No budgets found!'),
                ),
              for (YnabBudget budget in (budgets.value ?? []))
                CupertinoListTile(
                  title: Text(budget.name),
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: generateColor(budget.id),
                    ),
                    width: 18,
                    height: 18,
                  ),
                  additionalInfo: Row(
                    children: [
                      Icon(CupertinoIcons.timer, size: 16, color: CupertinoColors.systemGrey),
                      Gap(5),
                      Text(relativeDate(budget.lastModifiedOn)),
                    ],
                  ),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    ref.read(selectedYnabBudgetProvider.notifier).set(budget);

                    // Navigate to the budget detail screen.
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) => BudgetCategoriesView(),
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
