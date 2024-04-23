import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';

class SideNavigationDrawerModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onTapSearch() {
    _navigationService.navigateToSearchView();
  }

  void onTapSettings() {
    _navigationService.navigateToSettingsView();
  }
}
