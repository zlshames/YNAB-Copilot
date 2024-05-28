import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:ynab_copilot/app/screens/analytics/monthly_budgeted_spending_analytics.dart';
import 'package:ynab_copilot/app/widgets/category_widgets/category_list.dart';

class BudgetCategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Padding(
                // Add padding to the right to match the left so we can center the text
                padding: EdgeInsets.only(right: 50),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(CupertinoIcons.money_dollar_circle, size: 24),
                  Gap(5),
                  Text('Budget Categories', style: TextStyle(fontWeight: FontWeight.w500))
                ]))),
        // A ScrollView that creates custom scroll effects using slivers.
        child: SafeArea(
            child: Column(
          children: [MonthlyBudgetedSpendingAnalytics(forMonth: DateTime.now()), CategoryList()],
        )));
  }
}
