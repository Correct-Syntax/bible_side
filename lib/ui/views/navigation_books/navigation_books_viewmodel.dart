import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class NavigationBooksViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onTapBookItem(String bookCode) {
    _navigationService.navigateToNavigationSectionsChaptersView(bookCode: bookCode);
  }
}
