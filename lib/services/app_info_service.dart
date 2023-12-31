import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  Future<String> getAppVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }
}
