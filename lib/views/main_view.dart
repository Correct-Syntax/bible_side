import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/provider.dart';
import '../views/reader_view.dart';
import '../views/settings_view.dart';


class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context); 

    return appProvider.currentViewIndex == 0 ? 
      ReaderView(
        selectedIndex: appProvider.currentViewIndex,
        handleViewChanged: (index) {
          Navigator.of(context).pop();
          appProvider.currentViewIndex = index;
        },
      )
      : SettingsView(
          selectedIndex: appProvider.currentViewIndex,
          handleViewChanged: (index) {
            appProvider.currentViewIndex = index;
          },
      );
  }
}