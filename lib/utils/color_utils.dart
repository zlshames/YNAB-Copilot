import 'dart:ui';

/// Generate a color based on a string value
/// This color will be consistent for the same string value
Color generateColor(String value) {
  final int hash = value.hashCode;
  final int r = (hash & 0xFF0000) >> 16;
  final int g = (hash & 0x00FF00) >> 8;
  final int b = (hash & 0x0000FF);
  return Color.fromARGB(255, r, g, b);
}
