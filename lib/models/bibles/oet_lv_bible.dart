import '../../common/enums.dart';
import '../json_to_bible.dart';
import '../search_result.dart';

/// The OET Literal Version (OET-LV) implementation.
///
/// The OET-LV is displayed in sections verse-by-verse and does not contain section boxes.
class OETLiteralBibleImpl extends JsonToBible {
  OETLiteralBibleImpl(Map<String, dynamic> json) : super(json: json);

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

    String currentVerseId = '';
    String currentVerseNumber = '';
    String currentVerseText = '';
    bool hasPendingVerse = false;

    void flushVerse() {
      if (hasPendingVerse) {
        String formattedText = currentVerseText
            .replaceAll(RegExp(r'untr.*?untr\* ?'), '')
            .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
            .replaceAll(RegExp(r' +'), ' ')
            .replaceAll('>', '')
            .replaceAll('=', ' ')
            .replaceAll("'", "’");

        if (!showSpecialMarks) {
          formattedText = formattedText.replaceAll('_', ' ');
        }

        if (currentVerseNumber == '1') {
          String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';
          chapterNumberHtml =
              '\n                <span class="c" id="$chapterId">\n                    ${showChaptersAndVerses ? '$chapterNumber' : ''}\n                </span>';
        } else {
          chapterNumberHtml = '';
        }

        String bookmarkIcon = bookmarkIconHTML(currentVerseId, bookmarks);

        htmlText += '\n            <p class="p">'
            '$chapterNumberHtml$bookmarkIcon<sup id="$currentVerseId"> ${showChaptersAndVerses ? currentVerseNumber : ''}</sup>&nbsp;${formattedText.trim()}'
            '\n            </p>';

        hasPendingVerse = false;
        currentVerseText = '';
      }
    }

    if (json['content'] == null) {
      return htmlText;
    }

    for (Map item in json['content']) {
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];
      }

      if (item['type'] == 'para') {
        if (item['marker'] == 'p' ||
            item['marker'] == 'm' ||
            item['marker'] == 'q' ||
            item['marker'] == 'nb') {
          for (dynamic contentItem in item['content'] ?? []) {
            if (contentItem is Map) {
              if (contentItem['type'] == 'verse') {
                flushVerse();
                currentVerseNumber = contentItem['number'];
                currentVerseId =
                    '${readerArea.name}-$bookCode-$chapterNumber-$currentVerseNumber';
                hasPendingVerse = true;
              } else if (contentItem['type'] == 'char') {
                for (dynamic charItem in contentItem['content'] ?? []) {
                  if (charItem is String) currentVerseText += charItem;
                }
              }
            } else if (contentItem is String) {
              if (hasPendingVerse) {
                currentVerseText += contentItem;
              }
            }
          }
          flushVerse(); // Ensure we flush the last verse of the paragraph
        }
      }
    }

    return htmlText.trimLeft() + '\n';
  }

  @override
  Future<List<SearchResult>> getSearchResults(
      String bookCode, String searchTerm) async {
    // Search implementation for verses (handled globally or ignored here if searchHeaders is needed)
    return super.getSearchResults(bookCode, searchTerm);
  }
}
