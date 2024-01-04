import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/side_navigation_service.dart';

class HomeViewModel extends ReactiveViewModel {
  final _sideNavigationService = locator<SideNavigationService>();

  int get currentIndex => _sideNavigationService.currentIndex;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_sideNavigationService];
}
