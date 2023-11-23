import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/common.dart';
import '../core/provider.dart';
import '../widgets/nav_drawer.dart';


class SettingsView extends StatelessWidget {
  const SettingsView({super.key,
    required this.selectedIndex,
    required this.handleViewChanged,
  });

  final Function(int) handleViewChanged;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    AppSettingsProvider appSettingsProvider = Provider.of<AppSettingsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // On back button, return to reader view
        appProvider.currentViewIndex = 0;
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          shadowColor: null,
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark mode'),
              subtitle: const Text('Toggle dark interface theme'),
              trailing: Switch(
                value: appSettingsProvider.isDarkTheme, 
                onChanged: (bool value) {
                  appSettingsProvider.isDarkTheme = value;
                }
              )
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('BibleSide'),
              subtitle: FutureBuilder<String>(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('v${snapshot.data!}');
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
        drawer: SideNavigationDrawer(
          selectedIndex: selectedIndex,
          handleViewChanged: handleViewChanged,
        )
      ),
    );
  }
}