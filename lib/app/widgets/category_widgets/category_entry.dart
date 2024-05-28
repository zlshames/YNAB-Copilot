import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/app/screens/analytics/monthly_spending_volume_analytics.dart';
import 'package:ynab_copilot/app/widgets/category_widgets/category_progress.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/extensions/color_extensions.dart';
import 'package:ynab_copilot/utils/number_utils.dart';

enum CategoryEntrySize { small, medium, large, extraLarge }

final categoryEntrySizeMap = {
  CategoryEntrySize.small: 0.0,
  CategoryEntrySize.medium: 10.0,
  CategoryEntrySize.large: 20.0,
  CategoryEntrySize.extraLarge: 30.0,
};

class CategoryEntry extends ConsumerWidget {
  final YnabCategory category;
  final Function(YnabCategory)? onCategorySelected;
  final bool showProgress;
  final CategoryEntrySize size;

  CategoryEntry(
      {required this.category,
      this.onCategorySelected,
      this.showProgress = false,
      this.size = CategoryEntrySize.medium});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(selectedYnabBudgetProvider);
    print(budget?.currencyFormat);

    // Calculate the progress of the category based on the budgeted amount, activity amount, and balance amount
    // Try to convert the name to an emoji
    return CupertinoListTile(
      padding: EdgeInsets.all(categoryEntrySizeMap[size]!),
      title: Material(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    category.name,
                    style: TextStyle(color: category.color.withOpacity(0.75).darken(0.5), fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  backgroundColor: category.color.withOpacity(0.25),
                  // Rounded shape with border that matches category color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(color: category.color.withOpacity(0.5), width: 1)),
                  avatar: category.getIcon(size: 12)))),
      subtitle: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            children: [
              CategoryProgress(category: category),
              Gap(5),
              Row(
                children: [
                  Text(formatMoney(category.activityDollars * -1, showDecimals: false)),
                  Icon(
                      ((category.activityDollars * -1) < 0)
                          ? CupertinoIcons.arrow_down_left
                          : CupertinoIcons.arrow_up_right,
                      size: 16,
                      color: ((category.activityDollars * -1) < 0)
                          ? CupertinoColors.systemGreen.withOpacity(0.75)
                          : CupertinoColors.systemRed.withOpacity(0.75))
                ],
              ),
              Gap(5),
              // Rounded tag with category balance amount
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: category.completion.color.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(formatMoney(category.balanceDollars)),
              ),
            ],
          )),
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        // Navigate to the budget detail screen.
        Navigator.of(context).push(
          SwipeablePageRoute<void>(
            builder: (BuildContext context) => MonthlySpendingVolumeAnalytics(),
          ),
        );
      },
    );
  }
}
