import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class BiblesViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _biblesService = locator<BiblesService>();
  final _settingsService = locator<SettingsService>();

  String get primaryAreaBible => _biblesService.primaryAreaBible;
  String get secondaryAreaBible => _biblesService.secondaryAreaBible;

  bool get showSecondaryArea => _settingsService.showSecondaryArea;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  void setPrimaryAreaBible(String bibleCode) {
    _biblesService.setPrimaryAreaBible(bibleCode);
    rebuildUi();
  }

  void setSecondaryAreaBible(String bibleCode) {
    _biblesService.setSecondaryAreaBible(bibleCode);
    rebuildUi();
  }

  void onToggleSecondaryArea(bool value) {
    _settingsService.setShowSecondaryArea(value);
    rebuildUi();
  }

  void onToggleLinkReaderAreaScrolling(bool value) {
    _settingsService.setLinkReaderAreaScrolling(value);
    rebuildUi();
  }

  void onPopInvoked(bool onPopInvoked) async {
    _navigationService.navigateToReaderView();
  }
}
