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

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:material_symbols_icons/symbols.dart';

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

  Future<Map<String, dynamic>> loadJson(String path) async {
    final String data = await rootBundle.loadString(path);
    return json.decode(data);
  }

  List<TextItem> buildTextItemsBasedOnJson(Map<String, dynamic> json, BuildContext context) {
    List<TextItem> textItems = [];

    // Book data
    Map<String, dynamic> bookData = json['book'];
    //log(bookData.toString());
    List<dynamic> bookDataMeta = bookData['meta'];

    // for (Map<String, dynamic> meta in bookDataMeta) {
    //   //log(meta.toString());
    //   for (String key in meta.keys) {
    //     if (key == 'h') {
    //       textItems.add(ReaderTextWidgets.bookHeading(meta[key], context));
    //     }
    //   }
    // }

    // Chapters
    List<dynamic> chaptersData = json['chapters'];
    
    // Loop through chapter data
    for (Map<String, dynamic>chapter in chaptersData) {
      // Create chapter number
      textItems.add(ReaderTextWidgets.chapterHeading(chapter['chapterNumber'], context));

      //log(chapter.toString());
      // At this point we don't know what the datatype is going to be
      for (var chapterContents in chapter["contents"]) {
        //log(chapterContents.toString());

        if (chapterContents is List<dynamic>) {
          if (chapterContents[0] is Map<String, dynamic>) {
            log(chapterContents[0].toString());
            textItems.add(ReaderTextWidgets.sectionHeading(chapterContents[0]["s1"][0], context));
          }
        } else if (chapterContents is Map<String, dynamic>) {
          for (String key in chapterContents.keys) {
            //log(key.toString());
            if (key == "verseNumber") {
              textItems.add(ReaderTextWidgets.verseNumber(chapterContents[key], context));
            } else if (key == "verseText") {
              // Note: we remove Strongs numbers for now
              textItems.add(ReaderTextWidgets.verseText(chapterContents[key].replaceAll(RegExp(r"¦([0-9])\w+"), ''), context));

              //textItems.add(ReaderTextWidgets.verseLinkText('G5676', context));
            }
          }
        }
      }
    }
    return textItems;
  }

  /// 
  List<InlineSpan> buildReaderTextSpans(Map<String, dynamic> jsonData, BuildContext context) {
    List<InlineSpan> spans = [];

    for (var item in buildTextItemsBasedOnJson(jsonData, context)) {

      // Add space between chapters
      if (item.type == "chapterHeading" && item.text != ('Chapter 1')) {
        spans.add(const WidgetSpan(
          alignment: PlaceholderAlignment.top,
          baseline: TextBaseline.alphabetic,
          child: SizedBox(height: 50)
        ));
      } 

      TextSpan span;
      if (item.callback == null) {
        span = TextSpan(
          text: item.text,
          style: item.style,
        );
      } else {
        // Link
        span = TextSpan(
          text: item.text,
          style: item.style,
          recognizer: TapGestureRecognizer()..onTap = () => item.callback!(context),
        );
      }

      if (item.type == "verseNumber") {
        // Add space between verses
        spans.add(const WidgetSpan(
          alignment: PlaceholderAlignment.top,
          baseline: TextBaseline.alphabetic,
          child: SizedBox(height: 30)
        ));
      }

      spans.add(span);
    }
    return spans;
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
                  future: loadJson('assets/OET/LV/LV_ACTS.json'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      List<InlineSpan> spans = buildReaderTextSpans(snapshot.data!, context);
          
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
                  future: loadJson('assets/OET/RV/RV_ACTS.json'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      List<InlineSpan> spans = buildReaderTextSpans(snapshot.data!, context);
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