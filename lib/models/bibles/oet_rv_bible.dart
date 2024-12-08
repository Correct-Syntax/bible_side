import 'dart:developer';

import '../../common/enums.dart';
import '../json_to_bible.dart';

/// OET Reader's version implementation
class OETReadersBibleImpl extends JsonToBible {
  OETReadersBibleImpl(Map<String, dynamic> json) : super(json: json);

  // TODO: currently removes all ' marks.
  @override
  String getBook(String bookCode, ViewBy viewBy) {
    String htmlText = '';
    String chapterNumberHtml = '';

    String chapterNumber = '';
    String sectionVerseReference = '';
    List<dynamic> chapterContents = [];

    List<dynamic> chaptersData = json['chapters'];

    for (Map<String, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapterNumber'];

      chapterNumberHtml = '<span class="c" id="$bookCode$chapterNumber">$chapterNumber</span>';

      chapterContents = chapter['contents'];

      String sectionText = '';

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
          if (key == 's1') {
            sectionText = item['s1'];
            isSection = true;
          } else if (key == 'contents') {
            // Handle new paragraphs
            // We're looking for the indication of a new paragraph: "p" representing /p in the ESFM
            for (var innerMap in item[key]) {
              if (innerMap is Map) {
                if (innerMap.containsKey('s1')) {
                  if (innerMap['s1'] is String) {
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

          // Handle verse numbers
          if (key == 'verseNumber') {
            String verseNumberText = item[key];

            if (verseNumberText != '1') {
              chapterNumberHtml = '';
            }

            if (isNewParagraph == true) {
              // Add a new break between paragraphs
              isNewParagraph = false;
              if (verseNumberText == '1') {
                htmlText += '<p class="c" id="$bookCode$chapterNumber">';
              } else {
                // The end of a paragraph
                htmlText += '<p/>';
              }
            }
            sectionVerseReference = verseNumberText;

            if (isSection == false) {
              if (isNewParagraph == false) {
                htmlText += '<span><sup id="$bookCode$chapterNumber:$verseNumberText">$verseNumberText</sup>';
              } else {
                htmlText +=
                    '<p class="p">$chapterNumberHtml<sup id="$bookCode$chapterNumber:$verseNumberText">$verseNumberText</sup>';
              }
            }
          } else if (key == 'verseText') {
            // Note: we remove numbers and markings related to links for now
            String verseText;

            verseText = item[key]
                .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
                .replaceAll(' +', ' ')
                .replaceAll('>', ' ')
                .replaceAll('=', ' ');

            if (isSection == true && isNext == true) {
              htmlText +=
                  """<p class="p"><div class="section-box"><p><sup id="$bookCode$chapterNumber:$sectionVerseReference">$chapterNumber:$sectionVerseReference</sup> ${sectionText.replaceAll("'", "")}</p></div><span>$chapterNumberHtml<sup>$sectionVerseReference</sup>${verseText.replaceAll("'", "")}</span>""";

              isSection = false;
              isNext = false;
            } else {
              htmlText += "${verseText.replaceAll("'", "")}</span>";
            }
          }
        }
      }
    }

    log(htmlText);
    return htmlText;
  }
}
