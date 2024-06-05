import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../../common/enums.dart';


class SettingsThemeItemModel extends BaseViewModel {
  Color getForegroundColor(CurrentTheme theme) {
    switch (theme) {
      case CurrentTheme.light:
        return const Color(0xFF515358);
      case CurrentTheme.dark:
        return Colors.white;
      case CurrentTheme.sepia:
        return const Color(0xFF655F49);
      default:
        return const Color(0xFF515358);
    }
  }

  Color getBackgroundColor(CurrentTheme theme) {
    switch (theme) {
      case CurrentTheme.light:
        return Colors.white;
      case CurrentTheme.dark:
        return const Color(0xFF1F2123);
      case CurrentTheme.sepia:
        return const Color(0xFFC7C7AE);
      default:
        return Colors.white;
    }
  }
}
