import '../common/colors.dart';
import '../common/enums.dart';

abstract class JsonToBible {
  final Map<String, dynamic> json;

  JsonToBible({required this.json});

  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  Iterable<String> allStringMatches(String text, RegExp regExp) {
    Iterable<Match> matches = regExp.allMatches(text);
    List<Match> listOfMatches = matches.toList();

    Iterable<String> listOfStringMatches = listOfMatches.map((Match m) {
      return m.input.substring(m.start, m.end).trim();
    });

    return listOfStringMatches;
  }

  String bookmarkIconHTML(String verseId, List<String> bookmarks) {
    bool isBookmarked = bookmarks.contains(verseId.replaceAll('primary-', '').replaceAll('secondary-', ''));
    String svg =
        """<svg id="$verseId-svg" class="svg ${isBookmarked ? "bookmarked" : ""}" style="fill: ${verseId.textToHslColor()} !important;"  xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 256 256"><path d="M184,32H72A16,16,0,0,0,56,48V224a8,8,0,0,0,12.24,6.78L128,193.43l59.77,37.35A8,8,0,0,0,200,224V48A16,16,0,0,0,184,32Zm0,177.57-51.77-32.35a8,8,0,0,0-8.48,0L72,209.57V48H184Z"></path></svg>""";
    return svg;
  }

  String getBook(Area readerArea, String bookCode, List<String> bookmarks, ViewBy viewBy) {
    return '~';
  }
}
