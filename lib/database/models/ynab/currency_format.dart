class YnabCurrencyFormat {
  final String isoCode;
  final String exampleFormat;
  final int decimalDigits;
  final String decimalSeparator;
  final bool symbolFirst;
  final String groupSeparator;
  final String currencySymbol;
  final bool displaySymbol;

  YnabCurrencyFormat({
    required this.isoCode,
    required this.exampleFormat,
    required this.decimalDigits,
    required this.decimalSeparator,
    required this.symbolFirst,
    required this.groupSeparator,
    required this.currencySymbol,
    required this.displaySymbol,
  });

  factory YnabCurrencyFormat.fromJson(dynamic json) {
    return YnabCurrencyFormat(
      isoCode: json['iso_code'] as String,
      exampleFormat: json['example_format'] as String,
      decimalDigits: json['decimal_digits'] as int,
      decimalSeparator: json['decimal_separator'] as String,
      symbolFirst: json['symbol_first'] as bool,
      groupSeparator: json['group_separator'] as String,
      currencySymbol: json['currency_symbol'] as String,
      displaySymbol: json['display_symbol'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_code': isoCode,
      'example_format': exampleFormat,
      'decimal_digits': decimalDigits,
      'decimal_separator': decimalSeparator,
      'symbol_first': symbolFirst,
      'group_separator': groupSeparator,
      'currency_symbol': currencySymbol,
      'display_symbol': displaySymbol,
    };
  }
}

final defaultCurrencyFormat = YnabCurrencyFormat(
  isoCode: 'USD',
  exampleFormat: '123,456.78',
  decimalDigits: 2,
  decimalSeparator: '.',
  symbolFirst: true,
  groupSeparator: ',',
  currencySymbol: '\$',
  displaySymbol: true,
);
