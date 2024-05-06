import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../services/settings_service.dart';

class NavigationBibleDivisionsViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  List<String> get recentBooks => _settingsService.recentBooks;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  NavigationBibleDivisionsViewModel({required this.readerArea});

  final Area readerArea;

  String getTitle() {
    return '${linkReaderAreaScrolling == true ? '' : readerArea == Area.primary ? 'Primary' : 'Secondary'} Bible Nav';
  }

  void onTapBibleDivisionItem(String bibleDivisionCode) {
    // For Acts and Revelation, skip directly to choosing the section/chapter
    if (bibleDivisionCode == 'ACTS' || bibleDivisionCode == 'REVELATION') {
      String bookCode = '';
      if (bibleDivisionCode == 'ACTS') {
        bookCode = 'ACT';
      } else if (bibleDivisionCode == 'REVELATION') {
        bookCode = 'REV';
      }
      _navigationService.navigateToNavigationSectionsChaptersView(bookCode: bookCode);
    } else {
      _navigationService.navigateToNavigationBooksView(bibleDivisionCode: bibleDivisionCode);
    }
  }

  void onTapRecentBookItem(String bookCode) {
    _navigationService.navigateToNavigationSectionsChaptersView(bookCode: bookCode);
  }

  void onPopInvoked(bool onPopInvoked) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
