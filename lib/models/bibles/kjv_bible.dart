import 'dart:developer';
import '../../common/enums.dart';
import '../json_to_bible.dart';

/// King James Version (KJV) implementation.
///
/// The KJV is displayed in chapters verse-by-verse.
class KJVBibleImpl extends JsonToBible {
  KJVBibleImpl(Map<String, dynamic> json) : super(json: json);

  @override
  String getBook(Area readerArea, String bookCode, List<String> bookmarks, bool showSpecialMarks) {
    String htmlText = '';
    String chapterNumber = '';
    List<dynamic> chapterContents = [];

    List<dynamic> chaptersData = json['chapters'];

    for (Map<dynamic, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapter'];
      chapterContents = chapter['verses'];

      String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';

      String chapterNumberHtml = '''<span class="c" id="$chapterId">$chapterNumber</span>''';

      for (Map item in chapterContents) {
        String verseNumber = item['verse'];
        String verseText = item['text'];

        String verseId = '${readerArea.name}-$bookCode-$chapterNumber-$verseNumber';
        String bookmarkIcon = bookmarkIconHTML(verseId, bookmarks);

        if (verseNumber == '1') {
          htmlText +=
              """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">$chapterNumberHtml$bookmarkIcon<sup>$verseNumber</sup> $verseText</p>""";
        } else {
          htmlText +=
              """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">$bookmarkIcon<sup>$verseNumber</sup> $verseText</p>""";
        }
      }
    }

    return htmlText;
  }
}
