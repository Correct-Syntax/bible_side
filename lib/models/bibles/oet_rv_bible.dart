import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../ui/views/reader/widgets/inline_spans.dart';
import '../json_to_bible.dart';
import '../text_item.dart';
import 'oet_bibles.dart';

/// OET Reader's version implementation
class OETReadersBibleImpl extends JsonToBible with OETBaseMixin {
  OETReadersBibleImpl(BuildContext context, Map<String, dynamic> json) : super(context: context, json: json);

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

    bool isNewParagraph = false;
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

        List<TextSpan> wordSpans = [];
        // Handle verse numbers
        if (key == 'verseNumber') {
          String verseNumberText = item[key];

          // Verse numbers can either be the beginning of a verse or
          // potentially the beginning of a paragraph.
          if (isNewParagraph == true) {
            // Add a new break between paragraphs
            isNewParagraph = false;
          } else {
            verseNumberText = ' $verseNumberText ';
          }
          sectionVerseReference = verseNumberText;

          if (isSection == false) {
            verseSpans.add(TextSpan(
              text: verseNumberText,
              style: TextItemStyles.bodyMedium(context),
            ));
          }
        } else if (key == 'verseText') {
          String verseText;

          verseText = item[key]
              .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
              .replaceAll(' +', ' ')
              .replaceAll('>', ' ')
              .replaceAll('=', ' ');

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

  /// Get the OET chapter spans for [page]
  @override
  List<Map<String, dynamic>> getChapter(int page) {
    List<InlineSpan> spans = [];
    List<TextSpan> verseSpans = [];

    String sectionText = '';
    String sectionVerseReference = '';

    Map<String, List<dynamic>> jsonForChapter = getJsonForChapter(json, page);

    if (jsonForChapter.isNotEmpty) {
      String chapterNumber = jsonForChapter.keys.first;
      List<dynamic> chapterContentsJson = jsonForChapter.values.first;

      // Add first chapter number
      if (chapterNumber == '1') {
        spans.add(TextSpan(
          text: '$chapterNumber ',
          style: TextItemStyles.chapterHeading(context),
        ));
      }

      // In the current json, the section heading is placed in the verse
      // before the actual section, so we delay splitting the section with isNext
      // It means that this is the next verse after the 's1'.
      bool isNewParagraph = false;
      bool isNext = false;
      bool isSection = false;
      for (Map<String, dynamic> item in chapterContentsJson) {
        if (isSection == true && isNext == false) {
          isNext = true;
        }
        for (String key in item.keys) {
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

          List<TextSpan> wordSpans = [];

          // Handle verse numbers
          if (key == 'verseNumber') {
            String verseNumberText = item[key];

            if (isNewParagraph == true) {
              // Add a new break between paragraphs
              verseNumberText = verseNumberText == '1' ? ' $verseNumberText ' : verseNumberText;
              isNewParagraph = false;
            } else {
              verseNumberText = ' $verseNumberText ';
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
                  chapterNumber,
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
    }

    return [
      {
        'spans': spans,
        'page': page.toString(),
      }
    ];
  }
}
