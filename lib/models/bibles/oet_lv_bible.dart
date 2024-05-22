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
                if (innerMap['s1'] is String) {
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

  /// Get a single chapter defined by [pageKey] from the OET json.
  @override
  List<Map<String, dynamic>> getChapter(int page) {
    List<InlineSpan> spans = [];
    List<TextSpan> verseSpans = [];

    Map<String, List<dynamic>> jsonForChapter = getJsonForChapter(json, page);

    if (jsonForChapter.isNotEmpty) {
      String chapterNumber = jsonForChapter.keys.first;
      List<dynamic> chapterContentsJson = jsonForChapter.values.first;

      // Add chapter number
      spans.add(TextSpan(
        text: '$chapterNumber ',
        style: TextItemStyles.chapterHeading(context),
      ));

      for (Map<String, dynamic> item in chapterContentsJson) {
        for (String key in item.keys) {
          List<TextSpan> wordSpans = [];

          // Handle verse numbers
          if (key == 'verseNumber') {
            String verseNumberText = item[key];
            verseNumberText = verseNumberText == '1' ? ' $verseNumberText' : '\n$verseNumberText ';

            verseSpans.add(TextSpan(
              text: verseNumberText,
              style: TextItemStyles.bodyMedium(context),
            ));
          } else if (key == 'verseText') {
            // Note: we remove numbers and markings related to links for now
            String verseText;

            verseText = item[key]
                .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
                .replaceAll(' +', ' ')
                .replaceAll('>', ' ')
                .replaceAll('=', ' ');

            wordSpans.add(TextSpan(text: verseText));

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

    return [
      {
        'spans': spans,
        'page': page.toString(),
      }
    ];
  }
}
