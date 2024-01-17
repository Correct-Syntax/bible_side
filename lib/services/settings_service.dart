import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ListenableServiceMixin {
  SettingsService() {
    listenToReactiveValues([
      isDarkTheme,
      primaryAreaBible,
      secondaryAreaBible,
      bookCode,
      chapterNumber,
      sectionNumber,
    ]);
  }

  static const _kIsDarkTheme = 'IS_DARK_THEME';
  static const _kPrimaryAreaBibleCode = 'PRIMARY_AREA_BIBLE_CODE';
  static const _kSecondaryAreaBibleCode = 'SECONDARY_AREA_BIBLE_CODE';
  static const _kBookCode = 'BOOK_CODE';
  static const _kChapterNumber = 'CHAPTER_NUMBER';
  static const _kSectionNumber = 'SECTION_NUMBER';

  // TODO
  // setting to turn off verse numbers, chapter numbers
  // setting to turn off headings

  bool isDarkTheme = false;
  String primaryAreaBible = 'OET-RV';
  String secondaryAreaBible = 'OET-LV';
  String bookCode = 'JHN';
  int chapterNumber = 1;
  int sectionNumber = 1;

  Future<void> initilize() async {
    isDarkTheme = await getIsDarkTheme();
    primaryAreaBible = await getPrimaryAreaBible();
    secondaryAreaBible = await getSecondaryAreaBible();
    bookCode = await getBook();
    chapterNumber = await getChapterNumber();
    sectionNumber = await getSectionNumber();

    await setIsDarkTheme(isDarkTheme);
    await setPrimaryAreaBible(primaryAreaBible);
    await setSecondaryAreaBible(secondaryAreaBible);
    await setBook(bookCode);
    await setChapterNumber(chapterNumber);
    await setSectionNumber(sectionNumber);
  }

  // Is dark theme
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

  // Primary area bible code
  Future<void> setPrimaryAreaBible(String value) async {
    primaryAreaBible = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kPrimaryAreaBibleCode, value);
    notifyListeners();
  }

  Future<String> getPrimaryAreaBible() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    primaryAreaBible = prefs.getString(_kPrimaryAreaBibleCode) ?? 'OET-RV';
    return primaryAreaBible;
  }

  // Secondary area bible code
  Future<void> setSecondaryAreaBible(String value) async {
    secondaryAreaBible = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kSecondaryAreaBibleCode, value);
    notifyListeners();
  }

  Future<String> getSecondaryAreaBible() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    secondaryAreaBible = prefs.getString(_kSecondaryAreaBibleCode) ?? 'OET-LV';
    return secondaryAreaBible;
  }

  // Book code
  Future<void> setBook(String value) async {
    bookCode = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kBookCode, value);
    notifyListeners();
  }

  Future<String> getBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookCode = prefs.getString(_kBookCode) ?? 'JHN';
    return bookCode;
  }

  // Chapter number
  Future<void> setChapterNumber(int value) async {
    chapterNumber = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kChapterNumber, value);
    notifyListeners();
  }

  Future<int> getChapterNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chapterNumber = prefs.getInt(_kChapterNumber) ?? 1;
    return chapterNumber;
  }

  // Section number
  Future<void> setSectionNumber(int value) async {
    sectionNumber = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kSectionNumber, value);
    notifyListeners();
  }

  Future<int> getSectionNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sectionNumber = prefs.getInt(_kSectionNumber) ?? 1;
    return sectionNumber;
  }
}
