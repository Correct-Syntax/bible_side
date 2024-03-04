import 'package:bible_side/ui/views/home/home_view.dart';
import 'package:bible_side/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bible_side/services/bibles_service.dart';
import 'package:bible_side/services/settings_service.dart';
import 'package:bible_side/ui/views/settings/settings_view.dart';
import 'package:bible_side/ui/views/reader/reader_view.dart';
import 'package:bible_side/services/app_info_service.dart';
import 'package:bible_side/services/side_navigation_service.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:bible_side/services/reader_service.dart';
import 'package:bible_side/services/json_service.dart';
import 'package:bible_side/ui/views/reader_navigation/reader_navigation_view.dart';
import 'package:bible_side/ui/views/bibles/bibles_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ReaderView),
    MaterialRoute(page: ReaderNavigationView),
    MaterialRoute(page: BiblesView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BiblesService),
    LazySingleton(classType: SettingsService),
    LazySingleton(classType: AppInfoService),
    LazySingleton(classType: SideNavigationService),
    LazySingleton(classType: ThemeService),
    LazySingleton(classType: ReaderService),
    LazySingleton(classType: JsonService),
// @stacked-service
  ],
  // bottomsheets: [
  //   // @stacked-bottom-sheet
  // ],
  // dialogs: [
  //   // @stacked-dialog
  // ],
)
class App {}
