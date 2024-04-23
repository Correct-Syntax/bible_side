import 'package:stacked/stacked.dart';

import '../../../../../app/app.locator.dart';
import '../../../../../services/settings_service.dart';

class SettingsTextPreviewModel extends ReactiveViewModel {
  final _settingsService = locator<SettingsService>();

  double get textScaling => _settingsService.textScaling;


  @override
  List<ListenableServiceMixin> get listenableServices => [_settingsService];
}
