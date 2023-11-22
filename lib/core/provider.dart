import 'package:flutter/material.dart';

import 'settings.dart';


class AppProvider with ChangeNotifier {
  int _currentViewIndex = 0;
  
  int get currentViewIndex {
    return _currentViewIndex;
  }

  set currentViewIndex(int value) {
    _currentViewIndex = value;
    notifyListeners();
  }
}


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