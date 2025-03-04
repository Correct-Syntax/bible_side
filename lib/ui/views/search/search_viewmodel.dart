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

  String getSearchResultMessage(String searchTerm, String? sectionFilter, String currentBible) {
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
    _biblesService.setBook(BooksMapping.bookNameFromBookCode(bookCode));

    _biblesService.setChapter(chapter);
    _biblesService.setVerse(verse);
    _navigationService.clearStackAndShow(Routes.readerView);
  }

  void onPopInvoked(bool didPop, Object? result) async {
    _navigationService.clearStackAndShow(Routes.readerView);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_searchService];
}
