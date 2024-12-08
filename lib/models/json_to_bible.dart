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

  String getBook(String bookCode, ViewBy viewBy) {
    return '~';
  }
}
