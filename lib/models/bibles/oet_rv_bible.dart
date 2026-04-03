import '../../common/enums.dart';
import '../json_to_bible.dart';
import '../search_result.dart';

/// The OET Reader's Version (OET-RV) implementation
///
/// The OET-RV is displayed in sections paragraph-by-paragraph and contains section boxes.
class OETReadersBibleImpl extends JsonToBible {
  OETReadersBibleImpl(Map<String, dynamic> json) : super(json: json);

  // TODO: currently replaces all ' marks with ’.
  @override
  Future<String> getBook(
    Area readerArea,
    String bookCode,
    List<String> bookmarks,
    bool showSpecialMarks,
    bool showChaptersAndVerses,
  ) async {
    String htmlText = '';
    String chapterNumberHtml = '';
    String chapterNumber = '1';

    String sectionText = '';
    bool pendingSection = false;

    // State for assembling a verse
    String currentVerseId = '';
    String currentVerseNumber = '';
    String currentVerseText = '';
    bool hasPendingVerse = false;
    bool isVerseContinuing = false;

    void flushVerse({bool isEndOfPara = false}) {
      if (hasPendingVerse) {
        if (isVerseContinuing && currentVerseText.isEmpty) {
          // Skip empty continuations
        } else {
          // Note: we remove numbers and markings related to links for now
          String formattedText = currentVerseText
              .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
              .replaceAll(' +', ' ')
              .replaceAll('>', ' ')
              .replaceAll('=', ' ')
              .replaceAll("'", "’")
              .replaceAll("≈", "")
              .replaceAll("≡", "")
              .replaceAll("@", "");

          if (pendingSection) {
            String sectionId =
                '${readerArea.name}-$bookCode-$chapterNumber-$currentVerseNumber';
            htmlText +=
                '''</p><div class="section-box"><p><sup id="$sectionId">$chapterNumber:$currentVerseNumber</sup> ${sectionText.replaceAll('\'', '’')}</p></div><p>''';
            pendingSection = false;
          }

          String bookmarkIcon = isVerseContinuing
              ? ''
              : bookmarkIconHTML(currentVerseId, bookmarks);
          String supHtml = isVerseContinuing
              ? ''
              : '<sup id="$currentVerseId">${showChaptersAndVerses ? currentVerseNumber : ''}</sup>&nbsp;';

          htmlText +=
              '''<span class="p">$chapterNumberHtml$bookmarkIcon$supHtml$formattedText</span>''';

          chapterNumberHtml = '';
          currentVerseText = '';
        }

        if (isEndOfPara) {
          isVerseContinuing = true;
        } else {
          isVerseContinuing = false;
          hasPendingVerse = false;
        }
      } else if (!isEndOfPara) {
        hasPendingVerse = false;
        isVerseContinuing = false;
      }
    }

    if (json['content'] == null) {
      return htmlText;
    }

    for (Map item in json['content']) {
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];
        String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';
        chapterNumberHtml =
            '''<span class="c" id="$chapterId">${showChaptersAndVerses ? chapterNumber : ''}</span>''';
      }

      if (item['type'] == 'para') {
        if (item['marker'] == 's1' ||
            item['marker'] == 's2' ||
            item['marker'] == 's') {
          String text = '';
          for (dynamic contentItem in item['content'] ?? []) {
            if (contentItem is String) text += contentItem;
          }
          sectionText = text.trim();
          pendingSection = true;
        } else if (item['marker'] == 'p' ||
            item['marker'] == 'm' ||
            item['marker'].toString().startsWith('q') ||
            item['marker'] == 'sp') {
          htmlText += '<p>';

          for (dynamic contentItem in item['content'] ?? []) {
            if (contentItem is Map) {
              if (contentItem['type'] == 'verse') {
                flushVerse(isEndOfPara: false);
                currentVerseNumber = contentItem['number'];
                currentVerseId =
                    '${readerArea.name}-$bookCode-$chapterNumber-$currentVerseNumber';
                hasPendingVerse = true;
              } else if (contentItem['type'] == 'char') {
                for (dynamic charItem in contentItem['content'] ?? []) {
                  if (charItem is String) {
                    currentVerseText += charItem.replaceAll('≈', "");
                  }
                }
              }
            } else if (contentItem is String) {
              if (hasPendingVerse) {
                currentVerseText += contentItem;
              }
            }
          }

          flushVerse(isEndOfPara: true);
          htmlText += '</p>';
        }
      }
    }

    return htmlText;
  }

  Future<List<SearchResult>> searchHeaders(
      String bookCode, String searchTerm) async {
    List<SearchResult> results = [];
    String chapterNumber = '1';

    if (json['content'] == null) {
      return results;
    }

    for (int i = 0; i < json['content'].length; i++) {
      Map item = json['content'][i];

      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];
      }

      if (item['type'] == 'para') {
        if (item['marker'] == 's1' ||
            item['marker'] == 's2' ||
            item['marker'] == 's') {
          String text = '';
          for (dynamic contentItem in item['content'] ?? []) {
            if (contentItem is String) text += contentItem;
          }
          text = text.trim();

          if (text.toLowerCase().contains(searchTerm)) {
            // Find the verse number of the first verse following this header
            String nextVerseNumber = '1';
            for (int j = i + 1; j < json['content'].length; j++) {
              Map nextItem = json['content'][j];
              if (nextItem['type'] == 'para' && nextItem['content'] != null) {
                bool found = false;
                for (dynamic cItem in nextItem['content']) {
                  if (cItem is Map && cItem['type'] == 'verse') {
                    nextVerseNumber = cItem['number'];
                    found = true;
                    break;
                  }
                }
                if (found) break;
              } else if (nextItem['type'] == 'chapter') {
                break;
              }
            }

            results.add(SearchResult(
              bookCode: bookCode,
              chapter: int.parse(chapterNumber.isEmpty ? '1' : chapterNumber),
              verse: int.parse(nextVerseNumber.isEmpty ? '1' : nextVerseNumber),
              verseText: '[Header] ' + text,
            ));
          }
        }
      }
    }

    return results;
  }
}
