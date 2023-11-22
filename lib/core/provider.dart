import 'package:flutter/material.dart';

import 'settings.dart';


class AppProvider with ChangeNotifier {
  int _currentViewIndex = 0;

  String _currentBibleCode = 'OET';
  String _currentBookCode = 'JHN';
  
  // currentViewIndex
  int get currentViewIndex {
    return _currentViewIndex;
  }

  set currentViewIndex(int value) {
    _currentViewIndex = value;
    notifyListeners();
  }

  // currentBibleCode
  String get currentBibleCode {
    return _currentBibleCode;
  }

  set currentBibleCode(String value) {
    _currentBibleCode = value;
    notifyListeners();
  }

  // currentBookCode
  String get currentBookCode {
    return _currentBookCode;
  }

  set currentBookCode(String value) {
    _currentBookCode = value;
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