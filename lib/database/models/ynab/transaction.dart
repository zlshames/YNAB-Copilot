import 'package:objectbox/objectbox.dart';
import 'package:ynab_copilot/database/models/ynab/account.dart';
import 'package:ynab_copilot/database/models/ynab/category.dart';
import 'package:ynab_copilot/database/models/ynab/subtransaction.dart';

@Entity()
class YnabTransaction {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  final String id;

  @Property(type: PropertyType.date)
  DateTime date;

  int amount;
  String? memo;
  String cleared;
  bool approved;
  String? flagColor;
  String? flagName;
  String accountId;
  String accountName;
  String? payeeId;
  String? payeeName;
  String? matchedTransactionId;
  String? importId;
  String? importPayeeName;
  String? importPayeeNameOriginal;
  String? debtTransactionType;
  bool deleted;

  final transferAccountId = ToOne<YnabAccount?>();

  final transferTransactionId = ToOne<YnabTransaction?>();

  final category = ToOne<YnabCategory?>();

  @Backlink('transaction')
  final subtransactions = ToMany<YnabSubtransaction>();

  @Transient()
  double get amountInDollars => double.parse((amount / 1000).toStringAsFixed(2));

  @Transient()
  bool get isTransfer => transferAccountId.hasValue;

  @Transient()
  bool get isInflow => amount > 0;

  @Transient()
  bool get isOutflow => amount < 0;

  YnabTransaction(
      {required this.id,
      required this.date,
      required this.amount,
      this.memo,
      required this.cleared,
      this.approved = true,
      this.flagColor,
      this.flagName,
      required this.accountId,
      required this.accountName,
      this.payeeId,
      this.payeeName,
      this.matchedTransactionId,
      this.importId,
      this.importPayeeName,
      this.importPayeeNameOriginal,
      this.debtTransactionType,
      this.deleted = false});

  factory YnabTransaction.fromJson(dynamic json) {
    return YnabTransaction(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        amount: json['amount'] as int,
        memo: json['memo'] as String?,
        cleared: json['cleared'] as String,
        approved: json['approved'] as bool? ?? true,
        flagColor: json['flag_color'] as String?,
        flagName: json['flag_name'] as String?,
        accountId: json['account_id'] as String,
        accountName: json['account_name'] as String,
        payeeId: json['payee_id'] as String?,
        payeeName: json['payee_name'] as String?,
        matchedTransactionId: json['matched_transaction_id'] as String?,
        importId: json['import_id'] as String?,
        importPayeeName: json['import_payee_name'] as String?,
        importPayeeNameOriginal: json['import_payee_name_original'] as String?,
        debtTransactionType: json['debt_transaction_type'] as String?,
        deleted: json['deleted'] as bool? ?? false);
  }
}
