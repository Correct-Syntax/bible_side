import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../common/books.dart';
import '../../../common/themes.dart';
import '../../../models/search_result.dart';
import '../../common/ui_helpers.dart';
import 'search_viewmodel.dart';
import 'widgets/search_filter_bar/search_filter_bar.dart';
import 'widgets/search_result_item/search_result_item.dart';
import 'widgets/searchbar/searchbar.dart';

class SearchView extends StackedView<SearchViewModel> {
  const SearchView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SearchViewModel viewModel,
    Widget? child,
  ) {
    bool isPortrait = isPortraitOrientation(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: viewModel.onPopInvoked,
      child: Scaffold(
        backgroundColor: context.theme.appColors.background,
        appBar: isPortrait
            ? AppBar(
                backgroundColor: context.theme.appColors.background,
                centerTitle: true,
                scrolledUnderElevation: 0.0,
                automaticallyImplyLeading: true,
                title: Text(
                  'Search',
                  style: TextStyle(
                    color: context.theme.appColors.primary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Searchbar(
                  onSearch: (value) => viewModel.onSearch(value),
                ),
                SearchFilterBar(
                  selectedItem: viewModel.searchSectionFilter,
                  items: booksInSectionsMapping.keys.toList(),
                  onChangeItem: (item) => viewModel.onSelectSectionFilter(item),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 25.0, right: 25.0),
                  child: Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                  child: Text(
                    viewModel.isBusy
                        ? ''
                        : viewModel.getSearchResultMessage(
                            viewModel.searchTerm,
                            viewModel.searchSectionFilter,
                            viewModel.currentBible,
                          ),
                    style: TextStyle(
                      color: context.theme.appColors.secondary,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                viewModel.isBusy
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: CircularProgressIndicator(
                            color: context.theme.appColors.loadingSpinner,
                          ),
                        ),
                      )
                    : viewModel.searchResults.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.searchResults.length,
                              itemBuilder: (BuildContext context, int index) {
                                SearchResult searchResult = viewModel.searchResults[index];
                                return SearchResultItem(
                                  bookCode: searchResult.bookCode,
                                  chapter: searchResult.chapter,
                                  verse: searchResult.verse,
                                  verseText: searchResult.verseText,
                                  onTap: () => viewModel.onTapSearchResult(
                                    searchResult.bookCode,
                                    searchResult.chapter,
                                    searchResult.verse,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  SearchViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchViewModel();
}
