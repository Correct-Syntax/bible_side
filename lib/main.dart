/*
BibleSide Copyright 2023 Noah Rahm

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/main_view.dart';
import 'core/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppSettingsProvider appSettingsProvider = AppSettingsProvider();
   
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    appSettingsProvider.isDarkTheme = await appSettingsProvider.appSettings.getIsDarkTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppSettingsProvider>(
      create: (context) => appSettingsProvider,
      child: Consumer<AppSettingsProvider>(
        builder: (context, preferencesProvider, child) => MaterialApp(
          title: 'BibleSide',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              brightness: preferencesProvider.isDarkTheme ? Brightness.dark : Brightness.light, 
              seedColor: const Color.fromARGB(255, 18, 59, 89)
            ),
            useMaterial3: true,
          ),
          home: const MainView(),
        ),
      ),
    );
  }
}
