import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class SearchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void onPopInvoked(bool onPopInvoked) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
