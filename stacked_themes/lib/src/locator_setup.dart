import 'package:get_it/get_it.dart';
import 'package:stacked_themes/src/services/platform_service.dart'
    if (dart.library.js) 'package:stacked_themes/src/services/platform_service_web.dart';
import 'package:stacked_themes/src/services/shared_preferences_service.dart';
import 'package:stacked_themes/src/services/statusbar_service.dart'
    if (dart.library.js) 'package:stacked_themes/src/services/statusbar_service_web.dart';

final locator = GetIt.asNewInstance();

Future setupLocator() async {
  SharedPreferencesService sharedPreferences = await SharedPreferencesService.getInstance();
  locator.registerSingleton(sharedPreferences);

  locator.registerLazySingleton(() => StatusBarService());
  locator.registerLazySingleton(() => PlatformService());
}
