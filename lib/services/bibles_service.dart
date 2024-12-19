import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../common/books.dart';
import '../common/enums.dart';
import '../common/toast.dart';
import 'json_service.dart';
import 'settings_service.dart';

class BiblesService with ListenableServiceMixin {
  final _settingsService = locator<SettingsService>();
  final _jsonService = locator<JsonService>();

  BiblesService() {
    listenToReactiveValues([]);
  }

  Map<String, dynamic> primaryAreaJson = {};
  Map<String, dynamic> secondaryAreaJson = {};

  String get primaryBible => _settingsService.primaryBible;
  String get secondaryBible => _settingsService.secondaryBible;
  String get bookCode => _settingsService.bookCode;
  int get chapterNumber => _settingsService.chapterNumber;
  int get verseNumber => _settingsService.verseNumber;
  List<String> get recentBooks => _settingsService.recentBooks;
  ViewBy get viewBy => _settingsService.viewBy;

  Future<void> initilize() async {}

  Future<void> reloadBiblesJson() async {
    await loadBibleVersion(Area.primary);
    await loadBibleVersion(Area.secondary);
  }

  void setPrimaryAreaBible(String bibleCode) {
    _settingsService.setPrimaryAreaBible(bibleCode);
  }

  void setSecondaryAreaBible(String bibleCode) {
    _settingsService.setSecondaryAreaBible(bibleCode);
  }

  void setBook(String book) {
    _settingsService.setBook(book);
  }

  void setChapter(int newChapter) {
    _settingsService.setChapterNumber(newChapter);
  }

  void setVerse(int newVerse) {
    _settingsService.setVerseNumber(newVerse);
  }

  void setViewBy(ViewBy viewBy) {
    _settingsService.setNavViewBy(viewBy);
  }

  Future<void> loadBibleVersion(Area pane) async {
    if (pane == Area.primary) {
      revertToKJVIfOETBookNotAvailable(primaryBible, bookCode, Area.primary);
      primaryAreaJson = await _jsonService.loadBookJson(primaryBible, bookCode);
    } else if (pane == Area.secondary) {
      revertToKJVIfOETBookNotAvailable(secondaryBible, bookCode, Area.secondary);
      secondaryAreaJson = await _jsonService.loadBookJson(secondaryBible, bookCode);
    }
  }

  void revertToKJVIfOETBookNotAvailable(String thebibleCode, String theBookCode, Area area) {
    // To avoid problems loading books that don't exist yet in the OET,
    // automatically switch to the KJV.
    if ((isBibleOET(thebibleCode)) && uncompletedOETBooks.contains(theBookCode)) {
      if (area == Area.primary) {
        _settingsService.setPrimaryAreaBible('KJV');
      } else {
        _settingsService.setSecondaryAreaBible('KJV');
      }
      showToastMsg('Book is not available in the OET yet. Reverting to the KJV.');
    }
  }

  void addBookToRecentHistory(String book) {
    List<String> previousHistory = [];
    previousHistory = recentBooks;

    // Avoid inserting a duplicate
    if (previousHistory.contains(book) == false) {
      previousHistory.insert(0, book);
    }
    List<String> newHistory = previousHistory;

    // Constrain list to 3 books
    if (previousHistory.length >= 3) {
      newHistory = newHistory.sublist(0, 3);
    }
    _settingsService.setNavRecentBooks(newHistory);
  }

  bool isBibleOET(String bible) {
    return (bible == 'OET-RV' || bible == 'OET-LV');
  }

  bool isReaderBibleOET(Area readerArea) {
    if (readerArea == Area.primary) {
      return isBibleOET(primaryBible);
    } else if (readerArea == Area.secondary) {
      return isBibleOET(secondaryBible);
    } else {
      return false;
    }
  }
}
