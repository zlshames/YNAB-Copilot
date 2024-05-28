import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:ynab_copilot/database/models/ynab/currency_format.dart';

@Entity()
class YnabBudget {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  final String id;

  String name;
  @Property(type: PropertyType.date)
  DateTime lastModifiedOn;

  String firstMonth;
  String lastMonth;
  String dateFormat;

  @Transient()
  YnabCurrencyFormat? currencyFormat;

  String? get dbCurrencyFormat {
    return currencyFormat != null ? jsonEncode(currencyFormat!.toJson()) : '{}';
  }

  set dbCurrencyFormat(String? value) {
    currencyFormat = value != null ? YnabCurrencyFormat.fromJson(jsonDecode(value)) : null;
  }

  YnabBudget({
    required this.id,
    required this.name,
    required this.lastModifiedOn,
    required this.firstMonth,
    required this.lastMonth,
    required this.dateFormat,
  });

  factory YnabBudget.fromJson(dynamic json) {
    return YnabBudget(
        id: json['id'] as String,
        name: json['name'] as String,
        lastModifiedOn: DateTime.parse(json['last_modified_on'] as String),
        firstMonth: json['first_month'] as String,
        lastMonth: json['last_month'] as String,
        dateFormat: json['date_format']['format'] as String? ?? 'MM/DD/YYYY');
  }
}
