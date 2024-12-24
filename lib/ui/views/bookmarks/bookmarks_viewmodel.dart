import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../common/enums.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class BookmarksViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();
  final _navigationService = locator<NavigationService>();

  List<String> get bookmarks => _settingsService.bookmarks;
  ViewBy get viewBy => _settingsService.viewBy;

  String bookmarkIdToBookmark(String bookmarkId) {
    var [bookCode, chapter, verse] = bookmarkId.split('-');

    String bookName = BooksMapping.bookNameFromBookCode(bookCode);

    return '$bookName $chapter:$verse';
  }

  void onTapBookmark(String bookmarkId) {
    var [bookCode, chapter, verse] = bookmarkId.split('-');

    _biblesService.setBook(bookCode);
    _biblesService.setChapter(int.parse(chapter));
    _biblesService.setVerse(int.parse(verse));

    _navigationService.clearStackAndShow(Routes.readerView);
  }

  void deleteBookmark(String bookmark) async {
    List<String> allBookmarks = List.from(bookmarks);
    allBookmarks.remove(bookmark);
    await _settingsService.setBookmarks(allBookmarks);
  }

  void onPopInvoked(bool didPop, Object? result) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
