import 'dart:developer';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../common/enums.dart';
import '../common/mappings.dart';
import 'json_service.dart';

class BiblesService with ListenableServiceMixin {
  final _jsonService = locator<JsonService>();

  BiblesService() {
    listenToReactiveValues([chapter, bookCode, topBibleCode, bottomBibleCode, viewBy]);
  }
  // Idea: generate 
  // BibleVersion topBibleVersion = BibleVersion.oetReaders;
  // BibleVersion bottomBibleVersion = BibleVersion.oetLiteral;

  Map<String, dynamic> topJson = {};
  Map<String, dynamic> bottomJson = {};

  int chapter = 1;
  String bookCode = 'JHN';
  String topBibleCode = 'OET-RV';
  String bottomBibleCode = 'OET-LV';

  ViewBy viewBy = ViewBy.chapter;

  Future<void> initilize() async {
    // TODO: fetch settings
    await reloadBiblesJson();
  }

  Future<void> reloadBiblesJson() async {
    await loadBibleVersion(AreaType.top);
    await loadBibleVersion(AreaType.bottom);
  }

  void setBookCode(String book) {
    bookCode = book;
    notifyListeners();
  }

  void setChapter(int newChapter) {
    chapter = newChapter;
    notifyListeners();
  }

  void setViewBy(ViewBy view) {
    viewBy = view;
    notifyListeners();
  }

  Future<void> loadBibleVersion(AreaType areaType) async {
    if (areaType == AreaType.top) {
      topJson = await _jsonService.loadBookJson(topBibleCode, bookCode);
    } else if (areaType == AreaType.bottom) {
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
