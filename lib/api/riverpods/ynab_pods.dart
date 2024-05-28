import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ynab_copilot/database/models/ynab/budget.dart';
import 'package:ynab_copilot/database/models/app_settings.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/globals.dart';
import 'package:ynab_copilot/isolates/analytic_isolates.dart';
import 'package:ynab_copilot/utils/chart_utils.dart';

// Necessary for code-generation to work
part 'ynab_pods.g.dart';

@riverpod
Future<List<YnabBudget>> ynabBudgets(YnabBudgetsRef ref) async {
  return await ynab.getBudgets();
}

class SelectedYnabBudget extends StateNotifier<YnabBudget?> {
  // We initialize the list of todos to an empty list
  SelectedYnabBudget() : super(null);

  void set(YnabBudget budget) {
    state = budget;
  }
}

final selectedYnabBudgetProvider = StateNotifierProvider<SelectedYnabBudget, YnabBudget?>((ref) {
  return SelectedYnabBudget();
});

@riverpod
FutureOr<List<VerticalBarChartData>> monthlyTransactionVolume(
    MonthlyTransactionVolumeRef ref, List<YnabTransaction> transactions, DateTime month) async {
  if (transactions.isEmpty) return [];
  return await executeLoadMonthlyTransactionVolumeIsolate(transactions, month);
}
