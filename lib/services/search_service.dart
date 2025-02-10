class SearchService {
  String? _searchSectionFilter = null;
  String? get searchSectionFilter => _searchSectionFilter;

  List<Map<String, dynamic>> _searchResults = [
    {
      'book_code': 'GEN',
      'chapter': 1,
      'verse': 11,
      'verse_text':
          'Then God said, “Let the land produce vegetation: seed-bearing plants and trees on the land that bear fruit with seed in it, according to their various kinds.” And it was so.',
    }
  ];
  List<Map<String, dynamic>> get searchResults => _searchResults;

  void setSearchSectionFilter(String? item) {
    _searchSectionFilter = item;
  }
}
