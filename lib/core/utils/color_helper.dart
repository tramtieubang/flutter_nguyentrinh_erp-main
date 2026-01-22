import 'package:flutter/material.dart';

class ColorHelper {
  static Color hexToColor(String hex) {
    if (hex.isEmpty) return Colors.grey;

    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hex.replaceFirst('#', ''));

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
