import 'dart:developer';
import 'package:flutter/material.dart';

import '../app/app.locator.dart';
import '../models/text_item.dart';
import '../ui/views/reader/widgets/inline_spans.dart';
import 'bibles_service.dart';

class ReaderService {
  final _biblesService = locator<BiblesService>();

  String get topBibleCode => _biblesService.topBibleCode;
  String get topBookCode => _biblesService.bookCode;

  Map<String, dynamic> get topJson => _biblesService.topJson;
  Map<String, dynamic> get bottomJson => _biblesService.bottomJson;

  List<InlineSpan> getPaginatedVerses(int pageKey, BuildContext context) {
    _biblesService.setChapter(pageKey);
    return buildTextItemsFromOETJson(topJson, false, pageKey, context);
  }

  List<InlineSpan> buildTextItemsFromOETJson(Map<String, dynamic> json,
      bool splitByParagraph, int pageKey, BuildContext context) {
    List<InlineSpan> spans = [];
    List<TextSpan> verseSpans = [];

    String sectionText = '';
    String sectionChapterReference = '';
    String sectionVerseReference = '';

    // Book data
    Map<String, dynamic> bookData = json['book'];
    //log(bookData.toString());
    List<dynamic> bookDataMeta = bookData['meta'];

    // Idea: in the same way that we break up chapters by looking for a particular
    // chapter number, we could find a section by id.

    // Chapters
    List<dynamic> chaptersData = json['chapters'];

    String chapterNumber = '';
    List<dynamic> chapterContents = [];
    for (Map<String, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapterNumber'];
      //log(chapterNumber.toString()+pageKey.toString());
      if (chapterNumber == pageKey.toString()) {
        sectionChapterReference = chapterNumber;
        spans.add(TextSpan(
          text: 'Chapter $chapterNumber',
          style: TextItemStyles.chapterHeading(context),
        ));

        chapterContents = chapter['contents'];
        break;
      }
    }

    // We now have the chapter text
    //log(chapterContents.toString());

    bool isNewParagraph = false;
    bool isSection = false;
    for (Map<String, dynamic> item in chapterContents) {
      //log('>> '+item.toString()+'\n\n');

      for (String key in item.keys) {
        //log(key.toString()+'>>'+item.toString());
        if (key == 's1') {
          sectionText = item['s1'];
          isSection = true;
        } else if (key == 'contents') {
          // Handle new paragraphs
          // We're looking for the indication of a new paragraph: "p" representing /p in the ESFM
          for (var innerMap in item[key]) {
            if (innerMap is Map) {
              //log(innerMap.toString());

              if (innerMap.containsKey('s1')) {
                sectionText = innerMap['s1'];
                isSection = true;
              }

              if (innerMap.containsKey('p')) {
                isNewParagraph = true;
              }
            }
          }
        }
        //log(section.toString());

        // Handle verse numbers
        if (key == 'verseNumber') {
          String verseNumberText = item[key];

          // Verse numbers can either be the beginning of a verse or, in splitByParagraph
          // mode, potentially the beginning of a paragraph.
          if (isNewParagraph == true) {
            // Add a new break between paragraphs
            isNewParagraph = false;
          } else {
            if (splitByParagraph != true) {
              // Add newline between each verse
              verseNumberText = '\n$verseNumberText';
            }
          }
          sectionVerseReference = verseNumberText;

          if (isSection == false) {
            verseSpans.add(TextSpan(
              text: verseNumberText,
              style: TextItemStyles.bodyMedium(context),
            ));
          }
        } else if (key == 'verseText') {
          // Note: we remove Strongs numbers for now
          String verseText = item[key].replaceAll(RegExp(r'¦([0-9])\w+'), '');

          if (isSection == true) {
            spans.add(
              headingSectionSpan(
                context,
                verseText,
                sectionChapterReference,
                sectionVerseReference,
                sectionText,
              ),
            );
            isSection = false;
            verseSpans = [];
          }

          if (verseSpans.length == 1) {
            TextSpan verseTextSpan = TextSpan(
              text: verseText,
              style: TextItemStyles.text(context),
            );
            verseSpans.add(const TextSpan(text: ' ')); // spacer
            verseSpans.add(verseTextSpan);

            TextSpan span = TextSpan(
              children: verseSpans,
            );
            spans.add(span);
            verseSpans = [];
          }
        }
      }
    }

    // for (var item in textItems) {
    //   log(item.type.name.toString()+' | '+item.text.toString()+'\n');
    // }
    return spans;
  }
}
