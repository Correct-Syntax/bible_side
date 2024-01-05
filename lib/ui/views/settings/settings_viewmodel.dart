import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/app_info_service.dart';
import '../../../services/settings_service.dart';
import '../../../services/side_navigation_service.dart';

class SettingsViewModel extends FutureViewModel<String> {
  final _settingsService = locator<SettingsService>();
  final _appInfoService = locator<AppInfoService>();
  final _sideNavigationService = locator<SideNavigationService>();

  int get currentIndex => _sideNavigationService.currentIndex;
  bool get isDarkTheme => _settingsService.isDarkTheme;

  @override
  Future<String> futureToRun() => getAppVersion();

  void setCurrentIndex(int index) {
    _sideNavigationService.setCurrentIndex(index);
    rebuildUi();
  }

  void setIsDarkTheme(bool value) async {
    await _settingsService.setIsDarkTheme(value);
    rebuildUi();
  }

  Future<String> getAppVersion() async {
    String appVersion = await _appInfoService.getAppVersion();
    return 'v$appVersion';
  }

  void onPopInvoked(bool didPop) {
    setCurrentIndex(0);
  }
}
