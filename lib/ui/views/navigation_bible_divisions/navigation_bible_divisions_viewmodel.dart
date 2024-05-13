import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../common/enums.dart';
import '../../../common/toast.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class NavigationBibleDivisionsViewModel extends BaseViewModel {
  final _biblesService = locator<BiblesService>();
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  List<String> get recentBooks => _settingsService.recentBooks;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  NavigationBibleDivisionsViewModel({required this.readerArea});

  final Area readerArea;

  String getTitle() {
    return '${linkReaderAreaScrolling == true ? '' : readerArea == Area.primary ? 'Primary' : 'Secondary'} Bible Navigation';
  }

  bool isBibleOET() {
    return _biblesService.isReaderBibleOET(readerArea);
  }

  bool isItemDisabled(String bibleDivisionCode) {
    return uncompletedOETDivisions.contains(bibleDivisionCode) && isBibleOET();
  }

  void onTapBibleDivisionItem(String bibleDivisionCode, bool isDisabled) {
    if (isDisabled == true) {
      showToastMsg('These books are not yet completely drafted in the OET');
    } else {
      // For Acts and Revelation, skip directly to choosing the section/chapter
      if (bibleDivisionCode == 'ACTS' || bibleDivisionCode == 'REVELATION') {
        String bookCode = '';
        if (bibleDivisionCode == 'ACTS') {
          bookCode = 'ACT';
        } else if (bibleDivisionCode == 'REVELATION') {
          bookCode = 'REV';
        }
        _navigationService.navigateToNavigationSectionsChaptersView(readerArea: readerArea, bookCode: bookCode);
      } else {
        _navigationService.navigateToNavigationBooksView(readerArea: readerArea, bibleDivisionCode: bibleDivisionCode);
      }
    }
  }

  void onTapRecentBookItem(String bookCode) {
    _navigationService.navigateToNavigationSectionsChaptersView(readerArea: readerArea, bookCode: bookCode);
  }

  void onPopInvoked(bool onPopInvoked) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
