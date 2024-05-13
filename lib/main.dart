import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:stacked_services/stacked_services.dart';

// import 'app/app.bottomsheets.dart';
// import 'app/app.dialogs.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'common/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await ThemeManager.initialise();
  //setupDialogUi();
  //setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultThemeMode: ThemeMode.light,
      lightTheme: AppTheme.light,
      darkTheme: AppTheme.dark,
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        title: 'Bibleside',
        debugShowCheckedModeBanner: false,
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        initialRoute: Routes.startupView,
        onGenerateRoute: StackedRouter().onGenerateRoute,
        navigatorKey: StackedService.navigatorKey,
        navigatorObservers: [
          StackedService.routeObserver,
        ],
      ),
    );
  }
}
