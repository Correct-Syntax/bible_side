import 'dart:developer';
import '../../common/enums.dart';
import '../json_to_bible.dart';
import '../search_result.dart';

/// King James Version (KJV) implementation.
///
/// The KJV is displayed in chapters verse-by-verse.
class KJVBibleImpl extends JsonToBible {
  KJVBibleImpl(Map<String, dynamic> json) : super(json: json);

  @override
  Future<String> getBook(
    Area readerArea,
    String bookCode,
    List<String> bookmarks,
    bool showSpecialMarks,
    bool showChaptersAndVerses,
  ) async {
    String htmlText = '';
    String chapterNumber = '';
    List<dynamic> chapterContents = [];

    List<dynamic> chaptersData = json['chapters'];

    for (Map<dynamic, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapter'];
      chapterContents = chapter['verses'];

      String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';

      String chapterNumberHtml = '''<span class="c" id="$chapterId">
          ${showChaptersAndVerses ? chapterNumber : ''}
        </span>''';

      for (Map item in chapterContents) {
        String verseNumber = item['verse'];
        String verseText = item['text'];

        String verseId = '${readerArea.name}-$bookCode-$chapterNumber-$verseNumber';
        String bookmarkIcon = bookmarkIconHTML(verseId, bookmarks);

        if (verseNumber == '1') {
          htmlText += """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">
              $chapterNumberHtml$bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;$verseText
              </p>""";
        } else {
          htmlText += """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">
              $bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;$verseText
              </p>""";
        }
      }
    }

    return htmlText;
  }

  @override
  Future<List<SearchResult>> getSearchResults(String bookCode, String searchTerm) async {
    List<SearchResult> results = [];

    String chapterNumber = '';
    List<dynamic> chapterContents = [];

    List<dynamic> chaptersData = json['chapters'];

    for (Map<dynamic, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapter'];
      chapterContents = chapter['verses'];

      for (Map<dynamic, dynamic> verseContents in chapterContents) {
        String verseNumber = verseContents['verse'];
        String verseText = verseContents['text'];

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

    return results;
  }
}
