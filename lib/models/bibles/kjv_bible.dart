// ignore_for_file: prefer_single_quotes

import '../../common/enums.dart';
import '../json_to_bible.dart';

/// KJV version implementation
class KJVBibleImpl extends JsonToBible {
  KJVBibleImpl(Map<String, dynamic> json) : super(json: json);

  @override
  String getBook(String bookCode, ViewBy viewBy) {
    String htmlText = '';
    String chapterNumber = '';
    List<dynamic> chapterContents = [];

    List<dynamic> chaptersData = json['chapters'];

    for (Map<dynamic, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapter'];
      chapterContents = chapter['verses'];

      String chapterNumberHtml = """<span class="c" id="$bookCode$chapterNumber">$chapterNumber</span>""";

      for (Map item in chapterContents) {
        String verseNumber = item['verse'];
        String verseText = item['text'];

        if (verseNumber == '1') {
          htmlText +=
              """<p class="p" id="$bookCode$chapterNumber:$verseNumber">$chapterNumberHtml<sup>$verseNumber</sup> $verseText</p>""";
        } else {
          htmlText +=
              """<p class="p" id="$bookCode$chapterNumber:$verseNumber"><sup>$verseNumber</sup> $verseText</p>""";
        }
      }
    }
    return htmlText;
  }
}
