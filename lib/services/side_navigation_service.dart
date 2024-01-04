import 'package:stacked/stacked.dart';

class SideNavigationService with ListenableServiceMixin {
  SideNavigationService() {
    listenToReactiveValues([_currentIndex]);
  }
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
