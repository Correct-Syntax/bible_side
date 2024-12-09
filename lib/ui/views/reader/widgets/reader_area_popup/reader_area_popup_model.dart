import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../../app/app.locator.dart';
import '../../../../../app/app.router.dart';
import '../../../../../common/enums.dart';
import '../../../../../services/settings_service.dart';

class ReaderAreaPopupModel extends ReactiveViewModel {
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  String get primaryBible => _settingsService.primaryBible;
  String get secondaryBible => _settingsService.secondaryBible;

  bool get showSecondaryArea => _settingsService.showSecondaryArea;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  void onChangePrimaryBibleVersion() {
    _navigationService.clearStackAndShow(
      Routes.biblesView,
      arguments: const BiblesViewArguments(readerArea: Area.primary),
    );
  }

  void onChangeSecondaryBibleVersion() {
    _navigationService.clearStackAndShow(
      Routes.biblesView,
      arguments: const BiblesViewArguments(readerArea: Area.secondary),
    );
  }

  void onEnableSecondaryArea() {
    _settingsService.setShowSecondaryArea(true);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settingsService];
}
