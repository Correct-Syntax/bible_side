import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../models/search_result.dart';
import '../../../services/bibles_service.dart';
import '../../../services/search_service.dart';

class SearchViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _biblesService = locator<BiblesService>();
  final _searchService = locator<SearchService>();

  String get currentBible => _biblesService.primaryBible;

  String get searchTerm => _searchService.searchTerm;
  String? get searchSectionFilter => _searchService.searchSectionFilter;
  List<SearchResult> get searchResults => _searchService.searchResults;

  // Book and chapter selection state
  String? _selectedBookCode;
  int? _selectedChapter;

  String? get selectedBookCode => _selectedBookCode;
  int? get selectedChapter => _selectedChapter;

  // Get available chapters for the selected book
  List<int> get availableChapters {
    if (_selectedBookCode == null) return [];
    final totalChapters = bookNumOfChaptersMapping[_selectedBookCode] ?? 0;
    return List.generate(totalChapters, (index) => index + 1);
  }

  String getSearchResultMessage(
      String searchTerm, String? sectionFilter, String currentBible) {
    int numOfResults = searchResults.length;
    if (numOfResults == 0 && searchTerm == '') {
      return 'Search for a word or a passage in the $currentBible';
    } else if (numOfResults == 0 && searchTerm != '') {
      return 'No results found for "$searchTerm"';
    } else {
      if (sectionFilter == null) {
        return 'Showing $numOfResults passage${numOfResults > 1 ? 's' : ''} in the $currentBible for "$searchTerm"';
      } else {
        return 'Showing $numOfResults passage${numOfResults > 1 ? 's' : ''} in the $currentBible ${BooksMapping.sectionNameFromSectionCode(sectionFilter)} for "$searchTerm"';
      }
    }
  }

  Future<void> onSearch(String searchTerm) async {
    setBusy(true);
    _searchService.setSearchTerm(searchTerm);
    await _searchService.search();
    setBusy(false);
    rebuildUi();
  }

  Future<void> onSelectSectionFilter(String? item) async {
    setBusy(true);
    _searchService.setSearchSectionFilter(item);
    await _searchService.search();
    setBusy(false);
    rebuildUi();
  }

  void onTapSearchResult(String bookCode, int chapter, int verse) {
    //_biblesService.setBook(BooksMapping.bookNameFromBookCode(bookCode));
    _biblesService.setBook(bookCode);

    _biblesService.setChapter(chapter);
    _biblesService.setVerse(verse);
    _navigationService.clearStackAndShow(Routes.readerView);
  }

  void onPopInvoked(bool didPop, Object? result) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }

  // Handle book selection from dropdown
  void onBookSelected(String bookCode) {
    if (bookCode.isEmpty) {
      _selectedBookCode = null;
      _selectedChapter = null;
    } else {
      _selectedBookCode = bookCode;
      _selectedChapter = 1; // Default to chapter 1 when book changes
    }
    rebuildUi();
  }

  // Handle chapter selection from dropdown
  void onChapterSelected(int? chapter) {
    _selectedChapter = chapter;
    //Modified this function to navigate to the selected chapter imediately when chapter selected.
    //rebuildUi();

    _biblesService.setBook(_selectedBookCode!);

    _biblesService.setChapter(_selectedChapter!);
    _biblesService.setVerse(1);
    //_navigationService.clearStackAndShow(Routes.readerView);
    _navigationService.navigateTo(Routes.readerView);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_searchService];
}
