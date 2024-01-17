import 'dart:developer';
import 'package:flutter/material.dart';

import '../app/app.locator.dart';
import '../common/enums.dart';
import '../models/text_item.dart';
import '../ui/views/reader/widgets/inline_spans.dart';
import 'bibles_service.dart';
import 'settings_service.dart';

class ReaderService {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();

  Map<String, dynamic> get primaryAreaJson => _biblesService.primaryAreaJson;
  Map<String, dynamic> get secondaryAreaJson => _biblesService.secondaryAreaJson;

  String get primaryAreaBible => _settingsService.primaryAreaBible;
  String get secondaryAreaBible => _settingsService.secondaryAreaBible;

  ViewBy get viewBy => _biblesService.viewBy;

  /// A "Page" is a chapter in Chapter mode and a section in Section mode.
  /// An "Area" is the area in the reader where bible text is displayed and scrolled.

  /// Get a new page at [pageKey] for the current bible, book, etc and the given [Area].
  List<Map<String, dynamic>> getNewPage(BuildContext context, int pageKey, Area area) {
    if (area == Area.primary) {
      return pageFromJson(context, primaryAreaJson, primaryAreaBible, viewBy, pageKey);
    } else if (area == Area.secondary) {
      return pageFromJson(context, secondaryAreaJson, secondaryAreaBible, viewBy, pageKey);
    } else {
      return [];
    }
  }

  /// Get a page at [pageKey] that fits all of the given parameters.
  List<Map<String, dynamic>> pageFromJson(
      BuildContext context, Map<String, dynamic> json, String bibleCode, ViewBy viewBy, int pageKey) {
    if (bibleCode == 'OET-LV') {
      if (viewBy == ViewBy.chapter) {
        return chapterFromOETJson(context, json, true, pageKey);
      } else if (viewBy == ViewBy.section) {
        return sectionFromOETJson(context, json, true, pageKey);
      } else {
        return [];
      }
    } else if (bibleCode == 'OET-RV') {
      if (viewBy == ViewBy.chapter) {
        return chapterFromOETJson(context, json, false, pageKey);
      } else if (viewBy == ViewBy.section) {
        return sectionFromOETJson(context, json, false, pageKey);
      } else {
        return [];
      }
    } else {
      // Default to KJV
      return chapterFromKJVJson(context, json, pageKey);
    }
  }

  /// Get a single chapter defined by [pageKey] from the OET json.
  List<Map<String, dynamic>> chapterFromOETJson(
      BuildContext context, Map<String, dynamic> json, bool splitByParagraph, int pageKey) {
    List<InlineSpan> spans = [];
    List<TextSpan> verseSpans = [];

    String sectionText = '';
    String sectionChapterReference = '';
    String sectionVerseReference = '';

    // Book data
    Map<String, dynamic> bookData = json['book'];
    //log(bookData.toString());
    List<dynamic> bookDataMeta = bookData['meta'];

    // Chapters
    List<dynamic> chaptersData = json['chapters'];

    // Get the chapter at [pageKey]
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
    return [
      {
        'spans': spans,
        'page': chapterNumber,
      }
    ];
  }

  /// Get a single section defined by [pageKey] from the OET json.
  List<Map<String, dynamic>> sectionFromOETJson(
      BuildContext context, Map<String, dynamic> json, bool splitByParagraph, int pageKey) {
    List<InlineSpan> spans = [];

    // In the same way that we break up chapters by looking for a particular
    // chapter number, we find a section by the index.

    // return [
    //   {
    //     'spans': spans,
    //     'page': 1,
    //   }
    // ];
    // TODO: implement getting the section
    // Use the chapter method temporarily
    return chapterFromOETJson(context, json, false, pageKey);
  }

  /// Get a single chapter defined by [pageKey] from the KJV json.
  List<Map<String, dynamic>> chapterFromKJVJson(BuildContext context, Map<String, dynamic> json, int pageKey) {
    List<InlineSpan> spans = [];

    // Get the chapter at [pageKey]

    return [
      {
        'spans': spans,
        'page': 1,
      }
    ];
  }
}
