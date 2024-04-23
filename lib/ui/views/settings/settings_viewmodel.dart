import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/app_info_service.dart';
import '../../../services/settings_service.dart';

class SettingsViewModel extends FutureViewModel<String> {
  final _settingsService = locator<SettingsService>();
  final _appInfoService = locator<AppInfoService>();

  @override
  Future<String> futureToRun() => getAppVersion();

  double get textScaling => _settingsService.textScaling;
  bool get showMarks => _settingsService.showMarks;
  bool get showChaptersAndVerses => _settingsService.showChaptersAndVerses;

  bool get isDarkTheme => _settingsService.isDarkTheme;


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

  void setIsDarkTheme(bool value) async {
    await _settingsService.setIsDarkTheme(value);
    rebuildUi();
  }

  Future<String> getAppVersion() async {
    String appVersion = await _appInfoService.getAppVersion();
    return 'v$appVersion';
  }
}
