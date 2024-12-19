import 'package:flutter/material.dart';

// Hash code from https://stackoverflow.com/(CC BY-SA 4.0)
extension StringColor on String {
  Color textToColor() {
    if (isEmpty) {
      return Colors.black;
    }
    var hash = 0;
    for (var i = 0; i < length; i++) {
      hash = codeUnitAt(i) + ((hash << 5) - hash);
    }
    return HSLColor.fromColor(Colors.white).withHue(hash % 360.0).withSaturation(0.8).withLightness(0.54).toColor();
  }

  String textToHslColor() {
    if (isEmpty) {
      return 'hsl(0, 0%, 0%)';
    }
    var hash = 0;
    for (var i = 0; i < length; i++) {
      hash = codeUnitAt(i) + ((hash << 5) - hash);
    }

    return 'hsl(${hash % 360}, 80%, 54%)';
  }
}
