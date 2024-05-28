import 'package:objectbox/objectbox.dart';
import 'package:ynab_copilot/database/models/ynab/account.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/transaction.dart';

@Entity()
class YnabSubtransaction {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  final String id;

  int amount;
  String? memo;
  String? payeeId;
  String? payeeName;
  bool deleted;

  final transferAccountId = ToOne<YnabAccount?>();

  final transferTransactionId = ToOne<YnabTransaction?>();

  final category = ToOne<YnabCategory?>();

  final transaction = ToOne<YnabTransaction>();

  @Transient()
  double get amountInDollars => double.parse((amount / 1000).toStringAsFixed(2));

  @Transient()
  bool get isTransfer => transferAccountId.hasValue;

  @Transient()
  bool get isInflow => amount > 0;

  @Transient()
  bool get isOutflow => amount < 0;

  YnabSubtransaction({
    required this.id,
    required this.amount,
    this.memo,
    this.payeeId,
    this.payeeName,
    this.deleted = false,
  });

  factory YnabSubtransaction.fromJson(dynamic json) {
    return YnabSubtransaction(
      id: json['id'] as String,
      amount: json['amount'] as int,
      memo: json['memo'] as String?,
      payeeId: json['payee_id'] as String?,
      payeeName: json['payee_name'] as String?,
      deleted: json['deleted'] as bool? ?? false,
    );
  }
}
