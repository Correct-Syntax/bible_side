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
          NavigationDrawerDestination(
            label: Text(
              'Reader',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
            icon: const Icon(Icons.library_books_outlined),
            selectedIcon: const Icon(Icons.library_books),
          ),
          NavigationDrawerDestination(
            label: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
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
