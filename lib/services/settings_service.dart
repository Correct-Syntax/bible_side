import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import '../common/alphanum.dart';
import '../common/enums.dart';

class SettingsService with ListenableServiceMixin {
  SettingsService() {
    listenToReactiveValues([
      _showSecondaryArea,
      _primaryAreaBible,
      _secondaryAreaBible,
      _bookCode,
      _chapterNumber,
      _verseNumber,
      _recentBooks,
      _viewBy,
      _bookmarks,
    ]);
  }

  // Interface
  static const _kShowSecondaryArea = 'SHOW_SECONDARY_AREA';

  // Bibles
  static const _kPrimaryAreaBibleCode = 'PRIMARY_AREA_BIBLE_CODE';
  static const _kSecondaryAreaBibleCode = 'SECONDARY_AREA_BIBLE_CODE';
  static const _kBookCode = 'BOOK_CODE';
  static const _kChapterNumber = 'CHAPTER_NUMBER';
  static const _kVerseNumber = 'VERSE_NUMBER';

  // Navigation
  static const _kNavRecentBooks = 'NAV_RECENT_BOOKS';
  static const _kNavViewBy = 'NAV_VIEW_BY';

  // Bookmarks
  static const _kBookmarks = 'BOOKMARKS';

  // Reader view specifics
  static const _kTextScaling = 'TEXT_SCALING';
  static const _kShowMarks = 'SHOW_MARKS';
  static const _kShowChaptersAndVerses = 'SHOW_CHAPTERS_AND_VERSES';
  static const _kLinkReaderAreaScrolling = 'LINK_READER_AREA_SCROLLING';

  bool _showSecondaryArea = true;
  bool get showSecondaryArea => _showSecondaryArea;

  String _primaryAreaBible = 'OET-RV';
  String get primaryBible => _primaryAreaBible;
  String _secondaryAreaBible = 'OET-LV';
  String get secondaryBible => _secondaryAreaBible;
  String _bookCode = 'JHN';
  String get bookCode => _bookCode;
  int _chapterNumber = 1;
  int get chapterNumber => _chapterNumber;
  int _verseNumber = 1;
  int get verseNumber => _verseNumber;
  List<String> _recentBooks = [];
  List<String> get recentBooks => _recentBooks;
  ViewBy _viewBy = ViewBy.section;
  ViewBy get viewBy => _viewBy;

  List<String> _bookmarks = [];
  List<String> get bookmarks => _bookmarks;

  double _textScaling = 1.0;
  double get textScaling => _textScaling;
  bool _showMarks = true;
  bool get showMarks => _showMarks;
  bool _showChaptersAndVerses = true;
  bool get showChaptersAndVerses => _showChaptersAndVerses;
  bool _linkReaderAreaScrolling = true;
  bool get linkReaderAreaScrolling => _linkReaderAreaScrolling;

  Future<void> initilize() async {
    _showSecondaryArea = await getShowSecondaryArea();
    _primaryAreaBible = await getPrimaryAreaBible();
    _secondaryAreaBible = await getSecondaryAreaBible();
    _bookCode = await getBook();
    _chapterNumber = await getChapterNumber();
    _verseNumber = await getVerseNumber();
    _recentBooks = await getNavRecentBooks();
    _viewBy = await getNavViewBy();
    _bookmarks = await getBookmarks();
    _textScaling = await getTextScaling();
    _showMarks = await getShowMarks();
    _showChaptersAndVerses = await getShowChaptersAndVerses();
    _linkReaderAreaScrolling = await getLinkReaderAreaScrolling();

    await setShowSecondaryArea(_showSecondaryArea);
    await setPrimaryAreaBible(_primaryAreaBible);
    await setSecondaryAreaBible(_secondaryAreaBible);
    await setBook(_bookCode);
    await setChapterNumber(_chapterNumber);
    await setVerseNumber(_verseNumber);
    await setNavRecentBooks(_recentBooks);
    await setNavViewBy(_viewBy);
    await setTextScaling(_textScaling);
    await setShowMarks(_showMarks);
    await setShowChaptersAndVerses(_showChaptersAndVerses);
    await setLinkReaderAreaScrolling(_linkReaderAreaScrolling);
  }

  // Show secondary area
  Future<void> setShowSecondaryArea(bool value) async {
    _showSecondaryArea = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kShowSecondaryArea, value);
    notifyListeners();
  }

  Future<bool> getShowSecondaryArea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showSecondaryArea = prefs.getBool(_kShowSecondaryArea) ?? false;
    return _showSecondaryArea;
  }

  // Primary area bible code
  Future<void> setPrimaryAreaBible(String value) async {
    _primaryAreaBible = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kPrimaryAreaBibleCode, value);
    notifyListeners();
  }

  Future<String> getPrimaryAreaBible() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _primaryAreaBible = prefs.getString(_kPrimaryAreaBibleCode) ?? 'OET-RV';
    return _primaryAreaBible;
  }

  // Secondary area bible code
  Future<void> setSecondaryAreaBible(String value) async {
    _secondaryAreaBible = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kSecondaryAreaBibleCode, value);
    notifyListeners();
  }

  Future<String> getSecondaryAreaBible() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _secondaryAreaBible = prefs.getString(_kSecondaryAreaBibleCode) ?? 'OET-LV';
    return _secondaryAreaBible;
  }

  // Book code
  Future<void> setBook(String value) async {
    _bookCode = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kBookCode, value);
    notifyListeners();
  }

  Future<String> getBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _bookCode = prefs.getString(_kBookCode) ?? 'JHN';
    return _bookCode;
  }

  // Chapter number
  Future<void> setChapterNumber(int value) async {
    _chapterNumber = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kChapterNumber, value);
    notifyListeners();
  }

  Future<int> getChapterNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _chapterNumber = prefs.getInt(_kChapterNumber) ?? 1;
    return _chapterNumber;
  }

  // Verse number
  Future<void> setVerseNumber(int value) async {
    _verseNumber = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_kVerseNumber, value);
    notifyListeners();
  }

  Future<int> getVerseNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _verseNumber = prefs.getInt(_kVerseNumber) ?? 1;
    return _verseNumber;
  }

  // Recent books
  Future<void> setNavRecentBooks(List<String> value) async {
    _recentBooks = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_kNavRecentBooks, value);
    notifyListeners();
  }

  Future<List<String>> getNavRecentBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _recentBooks = prefs.getStringList(_kNavRecentBooks) ?? [];
    return _recentBooks;
  }

  // View by
  Future<void> setNavViewBy(ViewBy value) async {
    _viewBy = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_kNavViewBy, value.name);
    notifyListeners();
  }

  Future<ViewBy> getNavViewBy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _viewBy = ViewBy.values.byName(prefs.getString(_kNavViewBy) ?? 'section');
    return _viewBy;
  }

  // Bookmarks
  Future<void> setBookmarks(List<String> value) async {
    // Sort alphanumerally.
    value.sort(AlphanumComparator.compare);

    _bookmarks = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_kBookmarks, value);
    notifyListeners();
  }

  Future<List<String>> getBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _bookmarks = prefs.getStringList(_kBookmarks) ?? [];
    return _bookmarks;
  }

  // Text scaling
  Future<void> setTextScaling(double value) async {
    _textScaling = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(_kTextScaling, value);
    notifyListeners();
  }

  Future<double> getTextScaling() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textScaling = prefs.getDouble(_kTextScaling) ?? 1.0;
    return _textScaling;
  }

  // Show marks
  Future<void> setShowMarks(bool value) async {
    _showMarks = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kShowMarks, value);
    notifyListeners();
  }

  Future<bool> getShowMarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showMarks = prefs.getBool(_kShowMarks) ?? true;
    return _showMarks;
  }

  // Show chapter and verse numbers
  Future<void> setShowChaptersAndVerses(bool value) async {
    _showChaptersAndVerses = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kShowChaptersAndVerses, value);
    notifyListeners();
  }

  Future<bool> getShowChaptersAndVerses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showChaptersAndVerses = prefs.getBool(_kShowChaptersAndVerses) ?? true;
    return _showChaptersAndVerses;
  }

  // Link reader area scrolling
  Future<void> setLinkReaderAreaScrolling(bool value) async {
    _linkReaderAreaScrolling = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_kLinkReaderAreaScrolling, value);
    notifyListeners();
  }

  Future<bool> getLinkReaderAreaScrolling() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _linkReaderAreaScrolling = prefs.getBool(_kLinkReaderAreaScrolling) ?? true;
    return _linkReaderAreaScrolling;
  }
}
