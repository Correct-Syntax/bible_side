import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../services/settings_service.dart';

class BiblesViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();

  String get primaryBible => _settingsService.primaryBible;
  String get secondaryBible => _settingsService.secondaryBible;

  bool get showSecondaryArea => _settingsService.showSecondaryArea;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  BiblesViewModel({required this.readerArea});

  final Area readerArea;

  String getTitle() {
    return '${readerArea == Area.primary ? 'Primary' : 'Secondary'} Bible';
  }

  String currentBibleCode() {
    return (readerArea == Area.primary ? primaryBible : secondaryBible);
  }

  void setPrimaryAreaBible(String bibleCode) {
    _settingsService.setPrimaryAreaBible(bibleCode);
    rebuildUi();
  }

  void setSecondaryAreaBible(String bibleCode) {
    _settingsService.setSecondaryAreaBible(bibleCode);
    rebuildUi();
  }

  void onPopInvoked(bool didPop, Object? result) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
