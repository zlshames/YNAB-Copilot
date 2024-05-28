import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:ynab_copilot/api/riverpods/ynab_pods.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';
import 'package:ynab_copilot/utils/number_utils.dart';

class TransactionsList extends ConsumerWidget {
  final List<YnabTransaction> transactions;

  TransactionsList({required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(selectedYnabBudgetProvider);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('Done', style: TextStyle(color: CupertinoColors.activeBlue)),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          middle: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(children: [
                Icon(CupertinoIcons.money_dollar, size: 24),
                Gap(5),
                Text('Transactions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
              ]))),
      child: Padding(
          padding: EdgeInsets.only(top: 90),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: CupertinoListSection(
                    children: <CupertinoListTile>[
                      if (transactions.isEmpty)
                        const CupertinoListTile(
                          title: Text('No transactions found!'),
                        ),
                      for (YnabTransaction transaction in transactions)
                        CupertinoListTile(
                          title: Text(transaction.payeeName ?? transaction.memo ?? 'Payee Unknown'),
                          subtitle: Text(transaction.category.target?.name ?? 'Uncategorized'),
                          leading: (transaction.isOutflow)
                              ? Icon(CupertinoIcons.arrow_up_right_circle, size: 24, color: CupertinoColors.systemRed)
                              : Icon(CupertinoIcons.arrow_down_left_circle,
                                  size: 24, color: CupertinoColors.systemGreen),
                          additionalInfo: Row(
                            children: [
                              Text(formatMoney(transaction.amountInDollars, currencyFormat: budget!.currencyFormat!))
                            ],
                          ),
                        ),
                    ],
                  )),
            ],
          )),
    );
  }
}
