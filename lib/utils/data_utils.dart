Map<String, dynamic> groupTransactionsByCategory(List<dynamic> transactions) {
  final Map<String, dynamic> groupedTransactions = {};

  for (final transaction in transactions) {
    final category = transaction['category_name'] as String;
    if (groupedTransactions.containsKey(category)) {
      groupedTransactions[category].add(transaction);
    } else {
      groupedTransactions[category] = [transaction];
    }
  }

  return groupedTransactions;
}
