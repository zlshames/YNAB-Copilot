import 'package:objectbox/objectbox.dart';

@Entity()
class YnabAccount {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  final String id;

  String name;
  String type;
  bool onBudget;
  bool closed;
  String? note;
  int balance;
  int clearedBalance;
  int unclearedBalance;
  String? transferPayeeId;
  bool directImportLinked;
  bool directImportInError;

  @Property(type: PropertyType.date)
  DateTime? lastReconciledAt;

  bool deleted;

  YnabAccount({
    required this.id,
    required this.name,
    required this.type,
    required this.onBudget,
    required this.closed,
    this.note,
    required this.balance,
    required this.clearedBalance,
    required this.unclearedBalance,
    this.transferPayeeId,
    required this.directImportLinked,
    required this.directImportInError,
    this.lastReconciledAt,
    this.deleted = false,
  });

  factory YnabAccount.fromJson(dynamic json) {
    return YnabAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      onBudget: json['on_budget'] as bool,
      closed: json['closed'] as bool,
      note: json['note'] as String?,
      balance: json['balance'] as int,
      clearedBalance: json['cleared_balance'] as int,
      unclearedBalance: json['uncleared_balance'] as int,
      transferPayeeId: json['transfer_payee_id'] as String?,
      directImportLinked: json['direct_import_linked'] as bool,
      directImportInError: json['direct_import_in_error'] as bool,
      lastReconciledAt:
          json['last_reconciled_at'] != null ? DateTime.parse(json['last_reconciled_at'] as String) : null,
      deleted: json['deleted'] as bool,
    );
  }
}
