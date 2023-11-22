import 'package:flutter/material.dart';


class SideNavigationDrawer extends StatelessWidget {
  const SideNavigationDrawer({super.key,
    required this.selectedIndex,
    required this.handleViewChanged,
  });

  final Function(int) handleViewChanged;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NavigationDrawer(
      onDestinationSelected: handleViewChanged,
      selectedIndex: selectedIndex,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 40),
            child: Text(
              'BibleSide v0.0.1',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const NavigationDrawerDestination(
            label: Text("Reader"),
            icon: Icon(Icons.book_outlined), 
            selectedIcon: Icon(Icons.book)
          ),
          const NavigationDrawerDestination(
            label: Text("Settings"),
            icon: Icon(Icons.settings_outlined), 
            selectedIcon: Icon(Icons.settings)
          ),
        ],
      ),
    );
  }
}