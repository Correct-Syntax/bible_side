import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../common/enums.dart';

class SettingsService with ListenableServiceMixin {
  SettingsService() {
    listenToReactiveValues([
      isDarkTheme,
      showSecondaryArea,
      primaryAreaBible,
      secondaryAreaBible,
      bookCode,
      chapterNumber,
      sectionNumber,
      recentBooks,
      viewBy,
    ]);
  }

  // Interface
  static const _kIsDarkTheme = 'IS_DARK_THEME';
  static const _kShowSecondaryArea = 'SHOW_SECONDARY_AREA';

  // Bibles
  static const _kPrimaryAreaBibleCode = 'PRIMARY_AREA_BIBLE_CODE';
  static const _kSecondaryAreaBibleCode = 'SECONDARY_AREA_BIBLE_CODE';
  static const _kBookCode = 'BOOK_CODE';
  static const _kChapterNumber = 'CHAPTER_NUMBER';
  static const _kSectionNumber = 'SECTION_NUMBER';

  // Navigation
  static const _kNavRecentBooks = 'NAV_RECENT_BOOKS';
  static const _kNavViewBy = 'NAV_VIEW_BY';

  // Reader view specifics
  static const _kShowMarks = 'SHOW_MARKS';
  static const _kShowChaptersAndVerses = 'SHOW_CHAPTERS_AND_VERSES';

  bool isDarkTheme = false;
  bool showSecondaryArea = true;

  String primaryAreaBible = 'OET-RV';
  String secondaryAreaBible = 'OET-LV';
  String bookCode = 'JHN';
  int chapterNumber = 1;
  int sectionNumber = 0; // Section number starts at zero since it represents an index

  List<String> recentBooks = [];
  ViewBy viewBy = ViewBy.section;

  bool showMarks = true;
  bool showChaptersAndVerses = true;

  Future<void> initilize() async {
    isDarkTheme = await getIsDarkTheme();
    showSecondaryArea = await getShowSecondaryArea();
    primaryAreaBible = await getPrimaryAreaBible();
    secondaryAreaBible = await getSecondaryAreaBible();
    bookCode = await getBook();
    chapterNumber = await getChapterNumber();
    sectionNumber = await getSectionNumber();
    recentBooks = await getNavRecentBooks();
    viewBy = await getNavViewBy();

    await setIsDarkTheme(isDarkTheme);
    await setShowSecondaryArea(showSecondaryArea);
    await setPrimaryAreaBible(primaryAreaBible);
    await setSecondaryAreaBible(secondaryAreaBible);
    await setBook(bookCode);
    await setChapterNumber(chapterNumber);
    await setSectionNumber(sectionNumber);
    await setNavRecentBooks(recentBooks);
    await setNavViewBy(viewBy);
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

  // Show secondary area
  Future<void> setShowSecondaryArea(bool value) async {
    showSecondaryArea = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kShowSecondaryArea, value);
    notifyListeners();
  }

  Future<bool> getShowSecondaryArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showSecondaryArea = prefs.getBool(_kShowSecondaryArea) ?? false;
    return showSecondaryArea;
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
    sectionNumber = prefs.getInt(_kSectionNumber) ?? 0;
    return sectionNumber;
  }

  // Recent books
  Future<void> setNavRecentBooks(List<String> value) async {
    recentBooks = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_kNavRecentBooks, value);
    notifyListeners();
  }

  Future<List<String>> getNavRecentBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    recentBooks = prefs.getStringList(_kNavRecentBooks) ?? [];
    return recentBooks;
  }

  // View by
  Future<void> setNavViewBy(ViewBy value) async {
    viewBy = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kNavViewBy, value.name);
    notifyListeners();
  }

  Future<ViewBy> getNavViewBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    viewBy = ViewBy.values.byName(prefs.getString(_kNavViewBy) ?? 'section');
    return viewBy;
  }

  // Show marks
  Future<void> setShowMarks(bool value) async {
    showMarks = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kShowMarks, value);
    notifyListeners();
  }

  Future<bool> getShowMarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showMarks = prefs.getBool(_kShowMarks) ?? true;
    return showMarks;
  }

  // Show chapter and verse numbers
  Future<void> setShowChaptersAndVerses(bool value) async {
    showChaptersAndVerses = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kShowChaptersAndVerses, value);
    notifyListeners();
  }

  Future<bool> getShowChaptersAndVerses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showChaptersAndVerses = prefs.getBool(_kShowChaptersAndVerses) ?? true;
    return showChaptersAndVerses;
  }
}
