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

import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/provider.dart';
import '../core/reader_text.dart';
import '../widgets/reader_widgets.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/reader_navigation.dart';


class ReaderView extends StatefulWidget {
  const ReaderView({super.key,
    required this.selectedIndex,
    required this.handleViewChanged,
  });

  final Function(int) handleViewChanged;
  final int selectedIndex;

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {

  bool hideLiteralVersion = true;

  Map<String, dynamic> readersVersionText = {};
  Map<String, dynamic> literalVersiontext = {};

  late ScrollController readersVersionController;
  late ScrollController literalVersionController;
  late LinkedScrollControllerGroup parentController;

  
  @override
  void initState() {
    super.initState();
    parentController = LinkedScrollControllerGroup();
    readersVersionController = parentController.addAndGet();
    literalVersionController = parentController.addAndGet();
  }


  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ReaderNavigation(),
                fullscreenDialog: true
              )
            );
          },
          child: Text(bookCodeToBook(appProvider.currentBookCode))
        ),
        shadowColor: null,
      ),
      bottomSheet: hideLiteralVersion ? null : BottomSheet(
        elevation: 4,
        constraints: const BoxConstraints(maxHeight: 250),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              controller: literalVersionController,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: ReaderText(
                    appProvider.currentBibleCode, 
                    'LV', 
                    appProvider.currentBookCode
                  ).loadJson(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      List<InlineSpan> spans = ReaderContentBuilder().buildReaderTextSpans(snapshot.data!, context);
          
                      return RichText(
                        text: TextSpan(
                            children: spans
                          ),
                        );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator()
                      );
                    }
                  }
                ),
              )
            ),
          );
        },
        onClosing: () {},
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: readersVersionController,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: ReaderText(
                    appProvider.currentBibleCode,
                    'RV', 
                    appProvider.currentBookCode
                  ).loadJson(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      List<InlineSpan> spans = ReaderContentBuilder().buildReaderTextSpans(snapshot.data!, context);
                      return RichText(
                        text: TextSpan(
                          children: spans
                        )
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator()
                      );
                    }
                  }
                ),
              )
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            hideLiteralVersion = !hideLiteralVersion;
          });
        },
        elevation: 0.0,
        tooltip: 'Toggle literal version',
        child: Icon(hideLiteralVersion ? Symbols.expand_less : Symbols.expand_more),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            // IconButton(
            //   tooltip: 'Search',
            //   icon: const Icon(Icons.search),
            //   onPressed: () {},
            // ),
            IconButton(
              tooltip: 'Navigation',
              icon: const Icon(Icons.note_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReaderNavigation(),
                    fullscreenDialog: true
                  )
                );
              },
            ),
          ],
        ),
      ),
      drawer: SideNavigationDrawer(
        selectedIndex: widget.selectedIndex,
        handleViewChanged: widget.handleViewChanged,
      )
    );
  }
}