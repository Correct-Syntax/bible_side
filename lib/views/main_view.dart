import 'package:bible_side/views/reader_view.dart';
import 'package:bible_side/views/settings_view.dart';
import 'package:flutter/material.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  int currentViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return currentViewIndex == 0 ? 
      ReaderView(
        selectedIndex: currentViewIndex,
        handleViewChanged: (index) {
          Navigator.of(context).pop();
          setState(() {
            currentViewIndex = index;
          });
        },
      )
      : SettingsView(
          selectedIndex: currentViewIndex,
          handleViewChanged: (index) {
            Navigator.of(context).pop();
            setState(() {
              currentViewIndex = index;
            });
          },
      );
  }
}