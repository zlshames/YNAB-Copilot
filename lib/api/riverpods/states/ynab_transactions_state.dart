import 'package:ynab_copilot/database/models/ynab/transaction.dart';

enum YnabTransactionsStatus { initial, loading, loaded, error }

class YnabTransactionsState {
  YnabTransactionsState(
      {required this.budgetId, this.status = YnabTransactionsStatus.initial, this.transactions = const [], this.error});

  final String budgetId;
  YnabTransactionsStatus status;
  List<YnabTransaction> transactions;
  dynamic error;

  bool get isLoading => status == YnabTransactionsStatus.initial || status == YnabTransactionsStatus.loading;
  bool get hasResults => transactions.isNotEmpty;
  bool get didError => status == YnabTransactionsStatus.error;
  bool get hasError => didError && error != null;

  YnabTransactionsState copyWith(
      {required String budgetId, YnabTransactionsStatus? status, List<YnabTransaction>? transactions, dynamic error}) {
    return YnabTransactionsState(
        budgetId: budgetId,
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
        error: error ?? this.error);
  }
}
