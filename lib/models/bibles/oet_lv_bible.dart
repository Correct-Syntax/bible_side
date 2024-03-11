import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../ui/views/reader/widgets/inline_spans.dart';
import '../json_to_bible.dart';
import '../text_item.dart';
import 'oet_bibles.dart';

/// OET Literal version implementation
class OETLiteralBibleImpl extends JsonToBible with OETBaseMixin {
  OETLiteralBibleImpl(BuildContext context, Map<String, dynamic> json) : super(context: context, json: json);

  /// Get the section spans for [page], based on [sectionReferences]
  @override
  List<Map<String, dynamic>> getSection(int page, Map<String, dynamic> sectionReferences) {
    List<InlineSpan> spans = [];
    List<TextSpan> verseSpans = [];

    Map<String, int> sectionReferencesStart = sectionReferences['start']!;

    String sectionText = sectionReferences['section'];
    String sectionChapterReference = sectionReferencesStart['chapter'].toString();
    String sectionVerseReference = sectionReferencesStart['verse'].toString();

    List<dynamic> jsonForSection = getJsonForSection(json, sectionReferences);

    bool isNext = false;
    bool isSection = true;
    for (Map<String, dynamic> item in jsonForSection) {
      if (isSection == true && isNext == false) {
        isNext = true;
      }

      for (String key in item.keys) {
        if (key == 's1') {
          sectionText = item['s1'];
          isSection = true;
        } else if (key == 'contents') {
          for (var innerMap in item[key]) {
            if (innerMap is Map) {
              if (innerMap.containsKey('s1')) {
                if (innerMap['s1'].runtimeType == String) {
                  sectionText = innerMap['s1'];
                  isSection = true;
                }
              }
            }
          }
        }

        List<TextSpan> wordSpans = [];
        // Handle verse numbers
        if (key == 'verseNumber') {
          String verseNumberText = item[key];

          verseNumberText = verseNumberText == '1' ? ' $verseNumberText ' : '\n$verseNumberText';
          sectionVerseReference = verseNumberText;

          if (isSection == false) {
            verseSpans.add(TextSpan(
              text: verseNumberText,
              style: TextItemStyles.bodyMedium(context),
            ));
          }
        } else if (key == 'verseText') {
          String verseText;

          verseText = item[key];
          // .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
          // .replaceAll(' +', ' ')
          // .replaceAll('>', ' ')
          // .replaceAll('=', ' ');

          wordSpans.add(TextSpan(text: verseText));

          if (isSection == true && isNext == true) {
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
            isNext = false;
            verseSpans = [];
          }

          if (verseSpans.length == 1) {
            TextSpan verseTextSpan = TextSpan(
              children: wordSpans,
              //text: verseText,
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

    return [
      {
        'spans': spans,
        'page': page.toString(),
      }
    ];
  }

  /// Get a single chapter defined by [pageKey] from the OET json.
  @override
  List<Map<String, dynamic>> getChapter(int pageKey) {
    List<InlineSpan> spans = [];
    List<TextSpan> verseSpans = [];

    bool splitByParagraph = true; // LV is true

    String sectionText = '';
    String sectionChapterReference = '';
    String sectionVerseReference = '';

    // Book data
    Map<String, dynamic> bookData = json['book'];
    //log(bookData.toString());
    List<dynamic> bookDataMeta = bookData['meta'];

    // Chapters
    List<dynamic> chaptersData = json['chapters'];

    //log(pageKey.toString());

    // Get the chapter at [pageKey]
    String chapterNumber = '';
    List<dynamic> chapterContents = [];
    for (Map<String, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapterNumber'];
      log(chapterNumber.toString() + '|' + pageKey.toString());
      if (chapterNumber == pageKey.toString()) {
        sectionChapterReference = chapterNumber;
        if (splitByParagraph == true) {
          spans.add(TextSpan(
            text: '$chapterNumber ',
            style: TextItemStyles.chapterHeading(context),
          ));
        }
        chapterContents = chapter['contents'];
        break;
      }
    }

    // We now have the chapter text
    //log(chapterContents.toString());

    // In the current json, the section heading is placed in the verse
    // before the actual section, so we delay splitting the section with isNext
    // It means that this is the next verse after the 's1'.

    bool isNewParagraph = false;
    bool isNext = false;
    bool isSection = false;
    for (Map<String, dynamic> item in chapterContents) {
      if (isSection == true && isNext == false) {
        isNext = true;
      }
      for (String key in item.keys) {
        //log(key.toString()+'>>'+item.toString());
        if (key == 's1') {
          sectionText = item['s1'];
          isSection = true;
          //isNext = true;
        } else if (key == 'contents') {
          // Handle new paragraphs
          // We're looking for the indication of a new paragraph: "p" representing /p in the ESFM
          for (var innerMap in item[key]) {
            if (innerMap is Map) {
              if (innerMap.containsKey('s1')) {
                if (innerMap['s1'].runtimeType == String) {
                  sectionText = innerMap['s1'];
                  isSection = true;
                }
              }

              if (innerMap.containsKey('p')) {
                isNewParagraph = true;
              }
            }
          }
        }
        //log(section.toString());
        List<TextSpan> wordSpans = [];
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
              verseNumberText = verseNumberText == '1' ? ' $verseNumberText ' : '\n$verseNumberText';
            } else {
              verseNumberText = ' $verseNumberText ';
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
          // Note: we remove numbers and markings related to links for now
          String verseText = item[key]
              .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
              .replaceAll(' +', ' ')
              .replaceAll('>', ' ')
              .replaceAll('=', ' ');

          if (isSection == true && isNext == true) {
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
            isNext = false;
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

    return [
      {
        'spans': spans,
        'page': chapterNumber,
      }
    ];
  }
}
