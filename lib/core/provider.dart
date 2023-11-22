import 'package:flutter/material.dart';

import 'settings.dart';


class AppSettingsProvider with ChangeNotifier {
  AppSettings appSettings = AppSettings();
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    appSettings.setIsDarkTheme(value);
    notifyListeners();
  }
}