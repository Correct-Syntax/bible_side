import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../ui/views/reader/widgets/inline_spans.dart';
import '../json_to_bible.dart';
import '../text_item.dart';

// Shared code between the OET bible implementations
mixin OETBaseMixin {
  /// Given a [reference] like "1:3 Yeshua, alive, tells them to wait",
  /// returns "Yeshua, alive, tells them to wait".
  String sectionHeadingFromReference(String reference) {
    RegExp regex = RegExp(r'(\d*:\d*)');
    return reference.split(regex).last;
  }

  /// Get the section json between [sectionReferences]
  ///
  /// [sectionReferences] is a list of 2 strings formatted like ['1:11', '1:12']
  ///
  /// Returns a list of json contents
  List<dynamic> getJsonForSection(Map<String, dynamic> json, Map<String, dynamic> sectionReferences) {
    List<dynamic> sectionContents = [];

    // First get the chapter json where this section appears
    Map<String, int> startReference = sectionReferences['start']!;
    int startChapter = startReference['chapter']!;
    int startVerse = startReference['verse']!;
    Map<String, List<dynamic>> jsonForChapter = getJsonForChapter(json, startChapter);

    Map<String, int> endReference = sectionReferences['end']!;
    int endVerse = endReference['verse']!;

    if (jsonForChapter.isNotEmpty) {
      List<dynamic> chapterContentsJson = jsonForChapter.values.first;

      bool sectionStart = false;
      bool sectionEnd = false;

      for (Map<String, dynamic> item in chapterContentsJson) {
        // Find the start verse of the section
        if (item.containsKey('verseNumber') && sectionContents.isEmpty) {
          // If the starting verse is 1 then add the json for that verse
          if (startVerse == 1) {
            sectionContents.add(item);
            sectionStart = true;
            // We know that the section will start at this verse
          } else if (item['verseNumber'] == startVerse.toString()) {
            sectionContents.add(item);
            sectionStart = true;
          }
        } else {
          // Find the end verse of the section
          if (item.containsKey('verseNumber') && sectionStart == true) {
            if (item['verseNumber'] == endVerse.toString()) {
              sectionEnd = true;
            } else {
              sectionContents.add(item);
            }
          }
        }

        // We have the section contents, so exit loop
        if (sectionStart == true && sectionEnd == true) {
          break;
        }
      }
    }

    //log('${sectionContents.toString()});
    return sectionContents;
  }

  /// Get the chapter json at the chapter corresponding to [index].
  Map<String, List<dynamic>> getJsonForChapter(Map<String, dynamic> json, int index) {
    List<dynamic> chaptersData = json['chapters'];

    String chapterNumber = '';
    List<dynamic> chapterContents = [];
    for (Map<String, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapterNumber'];
      if (chapterNumber == index.toString()) {
        chapterContents = chapter['contents'];
        break;
      }
    }
    //log('$chapterNumber : ${chapterContents.toString()});
    return {
      chapterNumber: chapterContents,
    };
  }
}

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
      //log(item.toString());
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

          verseText = item[key] //;
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

    bool splitByParagraph = false;

    String sectionText = '';
    String sectionChapterReference = '';
    String sectionVerseReference = '';

    Map<String, List<dynamic>> jsonForChapter = getJsonForChapter(json, page);

    if (jsonForChapter.isNotEmpty) {
      String chapterNumber = jsonForChapter.keys.first;
      List<dynamic> chapterContentsJson = jsonForChapter.values.first;

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
    }

    return [
      {
        'spans': spans,
        'page': page.toString(),
      }
    ];
  }
}

/// OET Literal version implementation
class OETLiteralBibleImpl extends JsonToBible with OETBaseMixin {
  OETLiteralBibleImpl(BuildContext context, Map<String, dynamic> json) : super(context: context, json: json);

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
