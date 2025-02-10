import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../services/bibles_service.dart';
import '../../../services/search_service.dart';

class SearchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _biblesService = locator<BiblesService>();
  final _searchService = locator<SearchService>();

  String get currentBible => _biblesService.primaryBible;

  List<Map<String, dynamic>> get searchResults => _searchService.searchResults;
  String? get searchSectionFilter => _searchService.searchSectionFilter;

  String getSearchResultMessage(String? sectionFilter, String currentBible) {
    int numOfResults = searchResults.length;
    if (numOfResults == 0) {
      return 'Type to search for a word or a passage in the $currentBible';
    } else {
      if (sectionFilter == null) {
        return 'Showing $numOfResults passage${numOfResults > 1 ? 's' : ''} in the $currentBible';
      } else {
        return 'Showing $numOfResults passage${numOfResults > 1 ? 's' : ''} in the $currentBible ${BooksMapping.sectionNameFromSectionCode(sectionFilter)}';
      }
    }
  }

  void onSearch(String inputValue) {
    // TODO
  }

  void onSelectSectionFilter(String? item) {
    _searchService.setSearchSectionFilter(item);
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
}
