import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/provider.dart';
import '../widgets/nav_drawer.dart';


class SettingsView extends StatefulWidget {
  const SettingsView({super.key,
    required this.selectedIndex,
    required this.handleViewChanged,
  });

  final Function(int) handleViewChanged;
  final int selectedIndex;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {


  void handleViewChanged(int selected) {

  }

  @override
  Widget build(BuildContext context) {
    AppSettingsProvider appSettingsProvider = Provider.of<AppSettingsProvider>(context);

    return Scaffold(
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
        ],
      ),
      drawer: SideNavigationDrawer(
        selectedIndex: widget.selectedIndex,
        handleViewChanged: widget.handleViewChanged,
      )
    );
  }
}