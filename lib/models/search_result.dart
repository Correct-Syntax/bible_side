class SearchResult {
  SearchResult({
    required this.bookCode,
    required this.chapter,
    required this.verse,
    required this.verseText,
  });

  final String bookCode;
  final int chapter;
  final int verse;
  final String verseText;
}
