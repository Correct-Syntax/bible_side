import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../../widgets/common/side_navigation_drawer/side_navigation_drawer.dart';
import 'settings_viewmodel.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      onPopInvoked: viewModel.onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          shadowColor: null,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark mode'),
                subtitle: const Text('Toggle dark interface theme'),
                trailing: Switch(
                  value: viewModel.isDarkTheme,
                  onChanged: (bool value) async {
                    var themeManger = getThemeManager(context);
                    viewModel.setIsDarkTheme(value);
                    themeManger.setThemeMode(
                      value == true ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Bibleside'),
                subtitle: Text(viewModel.isBusy ? '' : viewModel.data!),
              ),
            ],
          ),
        ),
        drawer: SideNavigationDrawer(
          selectedIndex: viewModel.currentIndex,
          onViewChanged: viewModel.setCurrentIndex,
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsViewModel();
}
