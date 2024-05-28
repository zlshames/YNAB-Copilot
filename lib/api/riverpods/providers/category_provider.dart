import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ynab_copilot/api/riverpods/states/ynab_category_sync_state.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/category_group.dart';
import 'package:ynab_copilot/globals.dart';
import 'package:ynab_copilot/objectbox.g.dart';

part 'category_provider.g.dart';

@riverpod
class YnabCategorySyncController extends _$YnabCategorySyncController {
  @override
  YnabCategorySyncState build({required String budgetId}) {
    state = YnabCategorySyncState(budgetId: budgetId);
    return state;
  }

  void setStatus(YnabSyncStatus status, {bool notify = true}) {
    state.status = status;
    if (notify) ref.notifyListeners();
  }

  void setError(dynamic error, {bool notify = true}) {
    state.error = error;
    if (notify) ref.notifyListeners();
  }

  void reset() {
    state = YnabCategorySyncState(budgetId: state.budgetId);
    ref.notifyListeners();
  }

  Future<void> sync() async {
    setStatus(YnabSyncStatus.syncing);

    try {
      // Do the sync
      setStatus(YnabSyncStatus.complete, notify: false);
      ref.notifyListeners();

      // Fetch the categories & store them in the database
      final categories = await ynab.getBudgetCategories(state.budgetId);

      // Make sure the categories are linked to their parent category group
      for (final groups in categories) {
        groups.linkTransientCategories();
      }

      database.categoryGroups.putMany(categories, mode: PutMode.put);
    } catch (e, stack) {
      setError(e, notify: false);
      setStatus(YnabSyncStatus.error, notify: false);
      print(e);
      print(stack);
      ref.notifyListeners();
    }
  }
}

@riverpod
Stream<List<YnabCategoryGroup>> category(CategoryRef ref) async* {
  // Create a query builder to fetch all categories with their subcategories
  final listener = database.categoryGroups.query().watch(triggerImmediately: true);
  await for (final snapshot in listener) {
    yield snapshot.find();
  }
}
