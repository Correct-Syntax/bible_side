import 'package:stacked/stacked.dart';

import '../../../../app/app.locator.dart';
import '../../../../services/app_info_service.dart';

class SideNavigationDrawerModel extends FutureViewModel<String> {
  final _appInfoService = locator<AppInfoService>();

  @override
  Future<String> futureToRun() => getAppVersion();

  Future<String> getAppVersion() async {
    String appVersion = await _appInfoService.getAppVersion();
    return 'Bibleside v$appVersion';
  }
}
