enum YnabSyncStatus { initial, syncing, complete, error }

class YnabCategorySyncState {
  YnabCategorySyncState({required this.budgetId, this.status = YnabSyncStatus.initial, this.error});

  final String budgetId;
  YnabSyncStatus status;
  dynamic error;

  bool get isLoading => status == YnabSyncStatus.initial || status == YnabSyncStatus.syncing;
  bool get didError => status == YnabSyncStatus.error;
  bool get hasError => didError && error != null;

  YnabCategorySyncState copyWith(
      {required String budgetId,
      required DateTime startDate,
      required DateTime endDate,
      YnabSyncStatus? status,
      dynamic error}) {
    return YnabCategorySyncState(budgetId: budgetId, status: status ?? this.status, error: error ?? this.error);
  }
}
