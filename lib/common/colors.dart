import 'package:flutter/material.dart';

// From https://stackoverflow.com/a/76053830/ (CC BY-SA 4.0)
extension StringColor on String {
  Color textToColor() {
    if (isEmpty) {
      return Colors.black;
    }
    var hash = 0;
    for (var i = 0; i < length; i++) {
      hash = codeUnitAt(i) + ((hash << 5) - hash);
    }
    return Color(hash + 0xFF000000);
  }
}
