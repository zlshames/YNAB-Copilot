import 'dart:ui';

import 'package:ynab_copilot/database/models/ynab/transaction.dart';

class PieChartData {
  PieChartData(this.x, this.y, this.label, this.size, [this.color]);

  final String x;
  final double y;
  final String label;
  final Color? color;
  final String? size;
}

class VerticalBarChartData {
  VerticalBarChartData(this.x, this.y, this.label, this.transactions, {this.color});

  final String x;
  final double y;
  final String label;
  final Color? color;
  final List<YnabTransaction> transactions;
}

class LineChartData {
  LineChartData(this.x, this.y, this.label, {this.color});

  final String x;
  final double y;
  final String label;
  final Color? color;
}
