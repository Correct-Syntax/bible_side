import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();

  Future runStartupLogic() async {
    _settingsService.initilize();

    await _biblesService.initilize();

    _navigationService.replaceWithHomeView();
  }
}
