import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'side_navigation_drawer_model.dart';

class SideNavigationDrawer extends StackedView<SideNavigationDrawerModel> {
  const SideNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onViewChanged,
  });

  final int selectedIndex;
  final Function(int) onViewChanged;

  @override
  Widget builder(
    BuildContext context,
    SideNavigationDrawerModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      child: NavigationDrawer(
        onDestinationSelected: onViewChanged,
        selectedIndex: selectedIndex,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 40),
            child: Text(
              viewModel.isBusy ? '' : viewModel.data!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const NavigationDrawerDestination(
            label: Text('Reader'),
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
          ),
          const NavigationDrawerDestination(
            label: Text('Bibles'),
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
          ),
          const NavigationDrawerDestination(
            label: Text('Settings'),
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  @override
  SideNavigationDrawerModel viewModelBuilder(
    BuildContext context,
  ) =>
      SideNavigationDrawerModel();
}
