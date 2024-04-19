// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';
import 'package:stacked_themes/src/theme_service.dart';

import '../services/app_info_service.dart';
import '../services/bibles_service.dart';
import '../services/json_service.dart';
import '../services/reader_service.dart';
import '../services/settings_service.dart';
import '../services/side_navigation_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => BiblesService());
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => AppInfoService());
  locator.registerLazySingleton(() => SideNavigationService());
  locator.registerLazySingleton(() => ThemeService());
  locator.registerLazySingleton(() => ReaderService());
  locator.registerLazySingleton(() => JsonService());
}
