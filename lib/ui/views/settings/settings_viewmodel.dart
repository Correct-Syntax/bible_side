import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/app_info_service.dart';
import '../../../services/settings_service.dart';

class SettingsViewModel extends FutureViewModel<String> {
  final _settingsService = locator<SettingsService>();
  final _appInfoService = locator<AppInfoService>();
  final _navigationService = locator<NavigationService>();

  @override
  Future<String> futureToRun() => getAppVersion();

  double get textScaling => _settingsService.textScaling;
  bool get showMarks => _settingsService.showMarks;
  bool get showChaptersAndVerses => _settingsService.showChaptersAndVerses;

  void changeTextScaling(double value) {
    _settingsService.setTextScaling(value);
    rebuildUi();
  }

  void changeShowMarks(bool value) {
    _settingsService.setShowMarks(value);
    rebuildUi();
  }

  void changeShowChaptersAndVerses(bool value) {
    _settingsService.setShowChaptersAndVerses(value);
    rebuildUi();
  }

  Future<String> getAppVersion() async {
    String appVersion = await _appInfoService.getAppVersion();
    return 'v$appVersion';
  }

  void onPopInvoked(bool didPop, Object? result) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
