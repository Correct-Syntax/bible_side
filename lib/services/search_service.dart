import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../common/books.dart';
import '../models/bibles/kjv_bible.dart';
import '../models/search_result.dart';
import 'json_service.dart';

class SearchService with ListenableServiceMixin {
  final _jsonService = locator<JsonService>();

  SearchService() {
    listenToReactiveValues([
      _searchTerm,
      _searchSectionFilter,
      _searchResults,
    ]);
  }

  String _searchTerm = '';
  String get searchTerm => _searchTerm;

  String? _searchSectionFilter;
  String? get searchSectionFilter => _searchSectionFilter;

  List<SearchResult> _searchResults = [];
  List<SearchResult> get searchResults => _searchResults;

  void setSearchTerm(String text) {
    _searchTerm = text;
  }

  void setSearchSectionFilter(String? item) {
    _searchSectionFilter = item;
  }

  Future<void> search() async {
    List<SearchResult> results = [];
    List<String> booksToSearch = [];

    // Search the whole Bible.
    if (searchSectionFilter == '' || searchSectionFilter == null) {
      booksToSearch = booksMapping.keys.toList();
    } else {
      // Search just the books in the section specified by [searchSectionFilter].
      booksToSearch = BooksMapping.booksMappingFromBibleDivisionCode(searchSectionFilter!).keys.toList();
    }

    String cleanedSearchTerm = searchTerm.toLowerCase().trim();

    for (String bookCode in booksToSearch) {
      Map<String, dynamic> json = await _jsonService.loadBookJson('KJV', bookCode);
      var bibleImpl = KJVBibleImpl(json);
      List<SearchResult> bookSearchResults = await bibleImpl.getSearchResults(bookCode, cleanedSearchTerm);
      results.addAll(bookSearchResults);
    }

    _searchResults = results;
    notifyListeners();
  }
}
