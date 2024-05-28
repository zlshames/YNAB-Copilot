import 'dart:io';

import 'package:intl/intl.dart';
import 'package:ynab_copilot/database/models/ynab/currency_format.dart';

String formatMoney(double amount, {YnabCurrencyFormat? currencyFormat, bool showDecimals = true}) {
  YnabCurrencyFormat format = currencyFormat ?? defaultCurrencyFormat;
  final String currencySymbol = format.currencySymbol;
  final String isoCode = format.isoCode;
  int currencyDecimalDigits = format.decimalDigits;

  if (!showDecimals) {
    currencyDecimalDigits = 0;
  }

  // Remove the negative sign if the amount is zero
  if (amount == 0.0) {
    amount = amount.abs();
  }

  return NumberFormat.currency(
    locale: Platform.localeName,
    name: isoCode,
    symbol: currencySymbol,
    decimalDigits: currencyDecimalDigits,
  ).format(amount);
}
