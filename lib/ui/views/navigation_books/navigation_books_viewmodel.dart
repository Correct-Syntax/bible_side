import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../common/enums.dart';
import '../../../common/toast.dart';
import '../../../services/bibles_service.dart';

class NavigationBooksViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _biblesService = locator<BiblesService>();

  NavigationBooksViewModel({required this.readerArea});

  final Area readerArea;

  void onTapBookItem(String bookCode, bool isDisabled) {
    if (isDisabled == true) {
      showToastMsg('OET book has not been completed yet');
    } else {
      _navigationService.navigateToNavigationSectionsChaptersView(readerArea: readerArea, bookCode: bookCode);
    }
  }

  bool isItemDisabled(String bookCode) {
    return _biblesService.isReaderBibleOET(readerArea) && uncompletedOETBooks.contains(bookCode);
  }
}
