import 'package:shared_preferences/shared_preferences.dart';


class AppSettings {
  static const isDarkTheme = "DARK_THEME";

  Future<bool> setIsDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isDarkTheme, value);
  }

  Future<bool> getIsDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isDarkTheme) ?? false;
  }
}