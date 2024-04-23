import 'dart:ui';

class ChartData {
  ChartData(this.x, this.y, this.label, [this.color]);
  final String x;
  final double y;
  final String label;
  final Color? color;
}
