import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';

class NavigationBooksViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  NavigationBooksViewModel({required this.readerArea});

  final Area readerArea;

  void onTapBookItem(String bookCode) {
    _navigationService.navigateToNavigationSectionsChaptersView(readerArea: readerArea, bookCode: bookCode);
  }
}
