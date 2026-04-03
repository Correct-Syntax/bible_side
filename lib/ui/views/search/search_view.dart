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
import 'widgets/search_auto_complete_dropdown/search_auto_complete_dropdown.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: AutocompleteDropdown(
                          label: 'Book',
                          items: booksMapping.entries
                              .where(
                                  (e) => !uncompletedOETBooks.contains(e.key))
                              .map((e) =>
                                  DropdownItem(value: e.key, label: e.value))
                              .toList(),
                          onSelected: (selectedItem) =>
                              viewModel.onBookSelected(selectedItem.value),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        flex: 4,
                        child: DropdownMenu<int>(
                          key: ValueKey(viewModel.selectedBookCode),
                          enabled: viewModel.selectedBookCode != null,
                          label: const Text('Ch.'),
                          initialSelection: viewModel.selectedChapter,
                          dropdownMenuEntries: viewModel.availableChapters
                              .map((chapter) => DropdownMenuEntry(
                                    value: chapter,
                                    label: chapter.toString(),
                                  ))
                              .toList(),
                          onSelected: (chapter) =>
                              viewModel.onChapterSelected(chapter),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_rounded),
                        iconSize: 56,
                        tooltip: 'Go to book and chapter',
                        color: Colors.green[300],
                        onPressed: viewModel.selectedBookCode != null
                            ? () => viewModel
                                .onChapterSelected(viewModel.selectedChapter)
                            : null,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
                  child: Divider(
                    indent: 25.0,
                    endIndent: 25.0,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      'Advanced Search',
                      style: TextStyle(
                        color: context.theme.appColors.primary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Header Search',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Searchbar(
                    hintText: 'Search Headers…',
                    onSearch: (value) => viewModel.onSearchHeaders(value),
                  ),
                ),
                Center(
                  child: Text(
                    'Full-Text Search',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Searchbar(
                  onSearch: (value) => viewModel.onSearch(value),
                  hintText: 'Full-Text Search…',
                ),
                SearchFilterBar(
                  selectedItem: viewModel.searchSectionFilter,
                  items: booksInSectionsMapping.keys.toList(),
                  onChangeItem: (item) => viewModel.onSelectSectionFilter(item),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 25.0, right: 25.0),
                  child: Divider(
                    height: 0,
                    color: context.theme.appColors.divider,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 25.0),
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
                                SearchResult searchResult =
                                    viewModel.searchResults[index];
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
