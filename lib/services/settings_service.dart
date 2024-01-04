import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ListenableServiceMixin {
  SettingsService() {
    listenToReactiveValues([isDarkTheme]);
  }

  static const _kIsDarkTheme = 'IS_DARK_THEME';
  // setting to turn off verse numbers, chapter numbers
  // setting to turn off headings

  bool isDarkTheme = false;

  void initilize() async {
    isDarkTheme = await getIsDarkTheme();
    await setIsDarkTheme(isDarkTheme);
  }

  Future<void> setIsDarkTheme(bool value) async {
    isDarkTheme = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kIsDarkTheme, value);
    notifyListeners();
  }

  Future<bool> getIsDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool(_kIsDarkTheme) ?? false;
    return isDarkTheme;
  }
}
