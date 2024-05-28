import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ynab_copilot/api/riverpods/states/ynab_transactions_state.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/globals.dart';

part 'ynab_transactions_notifier.g.dart';

@riverpod
class YnabTransactionsController extends _$YnabTransactionsController {
  @override
  YnabTransactionsState build({required String budgetId}) {
    state = YnabTransactionsState(budgetId: budgetId);
    fetchTransactions();
    return state;
  }

  void setStatus(YnabTransactionsStatus status, {bool notify = true}) {
    state.status = status;
    if (notify) ref.notifyListeners();
  }

  void setTransactions(List<YnabTransaction> transactions, {bool notify = true}) {
    state.transactions = transactions;
    if (notify) ref.notifyListeners();
  }

  void setError(dynamic error, {bool notify = true}) {
    state.error = error;
    if (notify) ref.notifyListeners();
  }

  void reset() {
    state = YnabTransactionsState(budgetId: state.budgetId);
    ref.notifyListeners();
  }

  Future<void> fetchTransactions() async {
    setStatus(YnabTransactionsStatus.loading);
    try {
      final transactions = await ynab.getBudgetTransactions(budgetId);
      setTransactions(transactions, notify: false);
      setStatus(YnabTransactionsStatus.loaded, notify: false);
      ref.notifyListeners();
    } catch (e) {
      setError(e, notify: false);
      setStatus(YnabTransactionsStatus.error, notify: false);
      ref.notifyListeners();
    }
  }
}
