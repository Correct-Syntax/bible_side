import '../../common/enums.dart';
import '../json_to_bible.dart';

/// The OET Literal Version (OET-LV) implementation.
///
/// The OET-LV is displayed in sections verse-by-verse and does not contain section boxes.
class OETLiteralBibleImpl extends JsonToBible {
  OETLiteralBibleImpl(Map<String, dynamic> json) : super(json: json);

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

    String chapterNumber = '';
    List<dynamic> chapterContents = [];

    List<dynamic> chaptersData = json['chapters'];

    for (Map<String, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapterNumber'];

      chapterNumberHtml = '''<span class="c" id="${readerArea.name}-$bookCode-$chapterNumber">
          ${showChaptersAndVerses ? chapterNumber : ''}
          </span>''';

      chapterContents = chapter['contents'];

      // In the current json, the section heading is placed in the verse
      // before the actual section, so we delay splitting the section with isNext
      // It means that this is the next verse after the 's1'.
      bool isNext = false;
      bool isSection = false;
      for (Map<String, dynamic> item in chapterContents) {
        if (isSection == true && isNext == false) {
          isNext = true;
        }

        for (String key in item.keys) {
          if (key == 's1') {
            isSection = true;
          }

          // Handle verse numbers
          if (key == 'verseNumber') {
            String verseNumberText = item[key];

            if (verseNumberText != '1') {
              chapterNumberHtml = '';
            }

            if (isSection == false) {
              String verseId = '${readerArea.name}-$bookCode-$chapterNumber-$verseNumberText';
              String bookmarkIcon = bookmarkIconHTML(verseId, bookmarks);

              htmlText += '''<p ondblclick=onCreateBookmark("$verseId") class="p">
                  $chapterNumberHtml$bookmarkIcon<sup id="$verseId"> ${showChaptersAndVerses ? verseNumberText : ''}</sup>''';
            }
          } else if (key == 'verseText') {
            // Note: we remove numbers and markings related to links for now
            String verseText;

            verseText = item[key]
                .replaceAll(RegExp(r'¦([0-9])*\d+'), '')
                .replaceAll(' +', ' ')
                .replaceAll('>', ' ')
                .replaceAll('=', ' ');

            // Remove OET-LV special markings like _.
            if (showSpecialMarks == false) {
              verseText = verseText.replaceAll('_', ' ');
            }

            htmlText += "&nbsp;${verseText.replaceAll("'", "’")}</span>";
          }
        }
      }
    }

    return htmlText;
  }
}
