import 'dart:developer';
import '../../common/enums.dart';
import '../json_to_bible.dart';
import '../search_result.dart';

/// The World English Bible (WEB) implementation.
///
/// The WEB is displayed in chapters verse-by-verse.
class WEBBibleImpl extends JsonToBible {
  WEBBibleImpl(Map<String, dynamic> json) : super(json: json);

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
    String verseNumber = '1';

    for (Map item in json['content']) {
      // Chapter 'chapter'
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];

        String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';

        chapterNumberHtml = '''<span class="c" id="$chapterId">
          ${showChaptersAndVerses ? chapterNumber : ''}
        </span>''';
      }

      // Paragraph 'para'
      if (item['type'] == 'para') {
        // 'para' type items always have inner 'content'
        for (dynamic paraItem in item['content']) {
          if (paraItem is String) {
            if (item['marker'] == 'p') {
              String verseText = paraItem
                  .replaceAll('*j', '') // Remove leftover instances of j* from the original usfm
                  .replaceAll(RegExp(r'¦G([0-9])*\d+'), ''); // For now, remove all Strong's numbers

              htmlText += '$verseText</p>';
            }
          } else if (paraItem is Map) {
            String itemType = paraItem['type'];

            if (itemType == 'verse') {
              verseNumber = paraItem['number'];

              String verseId = '${readerArea.name}-$bookCode-$chapterNumber-$verseNumber';
              String bookmarkIcon = bookmarkIconHTML(verseId, bookmarks);

              if (verseNumber == '1') {
                htmlText += """<p ondblclick="onCreateBookmark("$verseId")" class="p" id="$verseId">
                  $chapterNumberHtml$bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;""";
              } else {
                htmlText += """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">
$bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;""";
              }
            }
          }
        }
      }
    }

    return htmlText;
  }

  @override
  Future<List<SearchResult>> getSearchResults(String bookCode, String searchTerm) async {
    List<SearchResult> results = [];

    String chapterNumber = '';
    String verseNumber = '';
    String verseText = '';

    for (Map item in json['content']) {
      // Chapter 'chapter'
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];
      }

      // Paragraph 'para'
      if (item['type'] == 'para') {
        // 'para' type items always have inner 'content'
        for (dynamic paraItem in item['content']) {
          if (paraItem is String) {
            if (item['marker'] == 'p') {
              verseText = paraItem
                  .replaceAll('*j', '') // Remove leftover instances of j* from the original usfm
                  .replaceAll(RegExp(r'¦G([0-9])*\d+'), ''); // For now, remove all Strong's numbers
            }
          } else if (paraItem is Map) {
            String itemType = paraItem['type'];

            if (itemType == 'verse') {
              verseNumber = paraItem['number'];

              bool isSearchTermInVerse = verseText.toLowerCase().contains(searchTerm);
              if (isSearchTermInVerse == true) {
                results.add(SearchResult(
                  bookCode: bookCode,
                  chapter: int.parse(chapterNumber),
                  verse: int.parse(verseNumber),
                  verseText: verseText,
                ));
              }
            }
          }
        }
      }
    }

    return results;
  }
}
