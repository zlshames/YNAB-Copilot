import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ynab_copilot/api/riverpods/providers/category_provider.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/app/widgets/category_widgets/category_entry.dart';
import 'package:ynab_copilot/app/widgets/loader.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';

class CategoryList extends HookConsumerWidget {
  CategoryList({this.showHidden = false, this.showProgress = false});

  final bool showHidden;
  final bool showProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(selectedYnabBudgetProvider);
    final categorySyncController = ref.watch(ynabCategorySyncControllerProvider(budgetId: budget?.id ?? ""));
    final categories = ref.watch(categoryProvider);

    // Use effect to sync the categories
    // This will only run once when the screen is loaded
    useEffect(() {
      // This delay is required to prevent updating the provider during build time
      Future.delayed(Duration.zero, () {
        ref.read(ynabCategorySyncControllerProvider(budgetId: budget?.id ?? "").notifier).sync();
      });

      return null;
    }, []);

    final isFinished = categories.hasValue || !categorySyncController.isLoading;

    // Filter out the Internal Master Category and Hidden Category Groups
    final filteredCategories = (categories.value ?? [])
        .where((group) =>
            !['Internal Master Category', 'Hidden Categories'].contains(group.name) && (showHidden || !group.hidden))
        .toList();

    return Expanded(
        child: SingleChildScrollView(
            child: (!isFinished)
                ? Center(child: Loader(text: 'Loading Categories...'))
                : Animate(
                    effects: [FadeEffect()],
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: filteredCategories.length,
                      itemBuilder: (BuildContext context, int index) {
                        final YnabCategoryGroup group = filteredCategories[index];
                        final List<YnabCategory> categories =
                            group.categories.where((category) => showHidden || !category.hidden).toList();
                        return CupertinoListSection(key: Key(group.id), header: Text(group.name), children: [
                          ...List.generate(categories.length, (index) {
                            return CategoryEntry(
                              category: categories[index],
                              showProgress: showProgress,
                            );
                          })
                        ]);
                      },
                    ))));
  }
}
