import 'dart:developer';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../common/enums.dart';
import '../common/mappings.dart';
import 'json_service.dart';

class BiblesService with ListenableServiceMixin {
  final _jsonService = locator<JsonService>();

  BiblesService() {
    listenToReactiveValues([chapter, bookCode, topBibleCode, bottomBibleCode, sectionIndex, viewBy]);
  }

  // BibleVersion topBibleVersion = BibleVersion.oetReaders;
  // BibleVersion bottomBibleVersion = BibleVersion.oetLiteral;

  Map<String, dynamic> topJson = {};
  Map<String, dynamic> bottomJson = {};

  int chapter = 1;
  String bookCode = 'JHN';

  String topBibleCode = 'OET-RV';
  String bottomBibleCode = 'OET-LV';

  String reference = '1:1';
  int sectionIndex = 1;

  ViewBy viewBy = ViewBy.chapter;

  Future<void> initilize() async {
    // TODO: fetch settings
  }

  Future<void> reloadBiblesJson() async {
    await loadBibleVersion(Area.top);
    await loadBibleVersion(Area.bottom);
  }

  void setBookCode(String book) {
    bookCode = book;
    notifyListeners();
  }

  void setChapter(int newChapter) {
    chapter = newChapter;
    notifyListeners();
  }

  void setSectionIndex(int index) {
    sectionIndex = index;
    notifyListeners();
  }

  void setViewBy(ViewBy view) {
    viewBy = view;
    notifyListeners();
  }

  Future<void> loadBibleVersion(Area pane) async {
    if (pane == Area.top) {
      topJson = await _jsonService.loadBookJson(topBibleCode, bookCode);
    } else if (pane == Area.bottom) {
      bottomJson = await _jsonService.loadBookJson(bottomBibleCode, bookCode);
    }
  }

  String bookCodeToBook(String bookCode) {
    return bookMapping[bookCode]!;
  }

  String bookToBookCode(String book) {
    return bookMapping.keys.firstWhere((item) => bookMapping[item] == book);
  }
}
