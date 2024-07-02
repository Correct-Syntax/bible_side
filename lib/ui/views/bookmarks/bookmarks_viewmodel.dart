import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/settings_service.dart';

class BookmarksViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  List<String> get bookmarks => _settingsService.bookmarks;

  void deleteBookmark(String bookmark) async {
    List<String> allBookmarks = List.from(bookmarks);
    allBookmarks.remove(bookmark);
    await _settingsService.setBookmarks(allBookmarks);
  }

  void onPopInvoked(bool onPopInvoked) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
