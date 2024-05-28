import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';

extension YnabCategoryGroupExt on List<YnabCategoryGroup> {
  // Get non-hidden categories from non-hidden groups,
  // excluding the internal master category group
  List<YnabCategory> get availableCategories {
    final groups =
        where((group) => !group.hidden && !['Internal Master Category', 'Hidden Category'].contains(group.name))
            .toList();

    // Only include categories that aren't hidden
    List<YnabCategory> categories = [];
    for (final group in groups) {
      categories.addAll(group.categories.where((category) => !category.hidden).toList());
    }

    return categories;
  }

  List<YnabCategoryGroup> get hiddenGroups {
    return where((group) => group.hidden).toList();
  }
}

extension YnabCategoryExt on List<YnabCategory> {
  // Get non-hidden categories
  List<YnabCategory> get availableCategories {
    return where((category) => !category.hidden).toList();
  }

  // Get hidden categories
  List<YnabCategory> get hiddenCategories {
    return where((category) => category.hidden).toList();
  }

  int get totalBudgeted {
    return fold(0, (previousValue, element) => previousValue + element.budgeted);
  }

  int get totalActivity {
    return fold(0, (previousValue, element) => previousValue + element.activity);
  }

  int get totalBalance {
    return fold(0, (previousValue, element) => previousValue + element.balance);
  }
}
