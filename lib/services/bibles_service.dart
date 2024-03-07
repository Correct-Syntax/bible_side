import 'dart:developer';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../common/enums.dart';
import '../common/books.dart';
import 'json_service.dart';
import 'settings_service.dart';

class BiblesService with ListenableServiceMixin {
  final _settingsService = locator<SettingsService>();
  final _jsonService = locator<JsonService>();

  BiblesService() {
    listenToReactiveValues([
      booksMapping,
    ]);
  }

  Map<String, dynamic> primaryAreaJson = {};
  Map<String, dynamic> secondaryAreaJson = {};

  Map<String, String> booksMapping = {};

  String get primaryAreaBible => _settingsService.primaryAreaBible;
  String get secondaryAreaBible => _settingsService.secondaryAreaBible;
  String get bookCode => _settingsService.bookCode;
  int get chapterNumber => _settingsService.chapterNumber;
  int get sectionNumber => _settingsService.sectionNumber;
  ViewBy get viewBy => _settingsService.viewBy;

  Future<void> initilize() async {
    setMappingBasedOnBible(primaryAreaBible);
  }

  Future<void> reloadBiblesJson() async {
    await loadBibleVersion(Area.primary);
    await loadBibleVersion(Area.secondary);
  }

  void setPrimaryAreaBible(String bibleCode) {
    _settingsService.setPrimaryAreaBible(bibleCode);
    setMappingBasedOnBible(bibleCode);
    notifyListeners();
  }

  void setSecondaryAreaBible(String bibleCode) {
    _settingsService.setSecondaryAreaBible(bibleCode);

    notifyListeners();
  }

  void setBook(String book) {
    _settingsService.setBook(book);
    notifyListeners();
  }

  void setChapter(int newChapter) {
    _settingsService.setChapterNumber(newChapter);
    notifyListeners();
  }

  void setSection(int newSection) {
    _settingsService.setSectionNumber(newSection);
    notifyListeners();
  }

  void setBooksMapping(BookMapping mapping) {
    booksMapping = getBookMapping(mapping);
    notifyListeners();
  }

  void setViewBy(ViewBy viewBy) {
    _settingsService.setNavViewBy(viewBy);
    notifyListeners();
  }

  Future<void> loadBibleVersion(Area pane) async {
    if (pane == Area.primary) {
      primaryAreaJson = await _jsonService.loadBookJson(primaryAreaBible, bookCode);
    } else if (pane == Area.secondary) {
      secondaryAreaJson = await _jsonService.loadBookJson(secondaryAreaBible, bookCode);
    }
  }

  String bookCodeToBook(String bookCode) {
    return booksMapping[bookCode]!;
  }

  String bookToBookCode(String book) {
    return booksMapping.keys.firstWhere((item) => booksMapping[item] == book);
  }

  void setMappingBasedOnBible(String bibleCode) {
    if (bibleCode == 'OET-RV' || bibleCode == 'OET-LV') {
      setBooksMapping(BookMapping.oet);
    } else {
      setBooksMapping(BookMapping.traditional);
    }
  }
}
