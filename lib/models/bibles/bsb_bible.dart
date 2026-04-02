import 'package:flutter/foundation.dart';

import '../../common/enums.dart';
import '../json_to_bible.dart';
import '../search_result.dart';

/// The Berean Standard Bible (BSB) implementation.
/// This code is based on the web_bible.dart implementation, since the BSB json has mostly the same structure as the WEB json.
/// The BSB is displayed in chapters verse-by-verse.

class BSBBibleImpl extends JsonToBible {
  BSBBibleImpl(Map<String, dynamic> json) : super(json: json);

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
      debugPrint('item: $item');
      // Chapter 'chapter'
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];

        String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';

        chapterNumberHtml = '''<span class="c" id="$chapterId">
          ${showChaptersAndVerses ? chapterNumber : ''}
        </span>''';
      }

      // Paragraph 'para': only want 'para' type items that have inner 'content'. 
      // The BSB json has some 'para' type items that are just empty paragraphs with no inner 'content', and we want to ignore those.
      else if (item['type'] == 'para' && item['content'] != null) {
        for (dynamic paraItem in item['content']) {
          if (paraItem is String) {
            // The BSB json has some q1 and q2 markers, in addition to p markers, so we want to include those as well.
            if (item['marker'] == 'p' || item['marker'] == 'q1' || item['marker'] == 'q2' ) {
              String verseText = paraItem;
              /*
              String verseText = paraItem
                // Not needed for BSB since there are no leftover usfm markers or Strong's numbers in the BSB json, but leaving this here in case we want to add support for another bible version that does have these issues.
                  .replaceAll('*j', '') // Remove leftover instances of j* from the original usfm
                  .replaceAll(RegExp(r'¦G([0-9])*\d+'), ''); // For now, remove all Strong's numbers
                htmlText += '$verseText</p>';
              */
              htmlText += '$paraItem</p>';
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

      // Paragraph 'para'.
      // The BSB has some 'para' type items that are just empty paragraphs with no inner 'content', so we want to check for null before iterating over 'content'.
       
      if (item['type'] == 'para' && item['content'] != null) {
        for (dynamic paraItem in item['content']) {
          if (paraItem is String) {
            if (item['marker'] == 'p' || item['marker'] == 'q1' || item['marker'] == 'q2' ) {
              /*verseText = paraItem
                  .replaceAll('*j', '') // Remove leftover instances of j* from the original usfm
                  .replaceAll(RegExp(r'¦G([0-9])*\d+'), ''); // For now, remove all Strong's numbers
                  */
              verseText = paraItem;
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
