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
import 'package:visibility_detector/visibility_detector.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../core/reader_text.dart';
import '../core/reader_widgets.dart';


class ReaderView extends StatefulWidget {
  const ReaderView({super.key});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {

  bool hideLiteralVersion = true;

  Map<String, dynamic> readersVersionText = {};
  Map<String, dynamic> literalVersiontext = {};

  late ReaderText mainReaderText;
  late ReaderText secondaryReaderText;
  late ScrollController readersVersionController;
  late ScrollController literalVersionController;
  late LinkedScrollControllerGroup parentController;

  
  @override
  void initState() {
    super.initState();
    parentController = LinkedScrollControllerGroup();
    readersVersionController = parentController.addAndGet();
    literalVersionController = parentController.addAndGet();

    mainReaderText = ReaderText('OET', 'RV', 'JHN');
    secondaryReaderText = ReaderText('OET', 'LV', 'JHN');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acts'),
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
                  future: secondaryReaderText.loadJson(),
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
                  future: mainReaderText.loadJson(),
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
            IconButton(
              tooltip: 'Open navigation menu',
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Study notes',
              icon: const Icon(Icons.note),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}