import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../../../common/enums.dart';

class SettingsThemeItemModel extends BaseViewModel {
  String getThemeName(CurrentTheme theme) {
    switch (theme) {
      case CurrentTheme.light:
        return 'Light';
      case CurrentTheme.dark:
        return 'Dark';
      case CurrentTheme.sepia:
        return 'Sepia';
      case CurrentTheme.contrast:
        return 'Contrast';
    }
  }

  Color getForegroundColor(CurrentTheme theme) {
    switch (theme) {
      case CurrentTheme.light:
        return const Color(0xFF515358);
      case CurrentTheme.dark:
        return Colors.white;
      case CurrentTheme.sepia:
        return const Color(0xFF655F49);
      case CurrentTheme.contrast:
        return const Color(0xFFFFFFFF);
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
      case CurrentTheme.contrast:
        return const Color(0xFF000000);
    }
  }
}
