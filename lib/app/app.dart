import 'package:bible_side/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bible_side/services/bibles_service.dart';
import 'package:bible_side/services/settings_service.dart';
import 'package:bible_side/ui/views/settings/settings_view.dart';
import 'package:bible_side/ui/views/reader/reader_view.dart';
import 'package:bible_side/services/app_info_service.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:bible_side/services/reader_service.dart';
import 'package:bible_side/services/json_service.dart';
import 'package:bible_side/ui/views/bibles/bibles_view.dart';
import 'package:bible_side/ui/views/search/search_view.dart';
import 'package:bible_side/ui/views/navigation_bible_divisions/navigation_bible_divisions_view.dart';
import 'package:bible_side/ui/views/navigation_books/navigation_books_view.dart';
import 'package:bible_side/ui/views/navigation_sections_chapters/navigation_sections_chapters_view.dart';
import 'package:bible_side/ui/views/bookmarks/bookmarks_view.dart';
import 'package:bible_side/services/search_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ReaderView),
    MaterialRoute(page: BiblesView),
    MaterialRoute(page: SearchView),
    MaterialRoute(page: NavigationBibleDivisionsView),
    MaterialRoute(page: NavigationBooksView),
    MaterialRoute(page: NavigationSectionsChaptersView),
    MaterialRoute(page: BookmarksView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: BiblesService),
    LazySingleton(classType: SettingsService),
    LazySingleton(classType: AppInfoService),
    LazySingleton(classType: ThemeService),
    LazySingleton(classType: ReaderService),
    LazySingleton(classType: JsonService),
    LazySingleton(classType: SearchService),
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
