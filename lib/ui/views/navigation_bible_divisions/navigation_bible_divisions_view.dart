import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../common/books.dart';
import '../../../common/enums.dart';
import '../../../common/themes.dart';
import '../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'navigation_bible_divisions_viewmodel.dart';

class NavigationBibleDivisionsView extends StackedView<NavigationBibleDivisionsViewModel> {
  const NavigationBibleDivisionsView({
    Key? key,
    required this.readerArea,
  }) : super(key: key);

  final Area readerArea;

  @override
  Widget builder(
    BuildContext context,
    NavigationBibleDivisionsViewModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      onPopInvoked: viewModel.onPopInvoked,
      child: Scaffold(
        backgroundColor: context.theme.appColors.background,
        appBar: AppBar(
          backgroundColor: context.theme.appColors.background,
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          title: Text(
            viewModel.getTitle(),
            style: TextStyle(
              color: context.theme.appColors.primary,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: booksMapping.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    String bibleDivisionCode = BooksMapping.bibleDivisionCodeFromIndex(index);
                    return InkWell(
                      onTap: () => viewModel.onTapBibleDivisionItem(bibleDivisionCode),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 13.0, right: 8),
                                    child: BibleDivisionIndicator(
                                      color: BooksMapping.colorFromBibleDivisionCode(bibleDivisionCode),
                                    ),
                                  ),
                                ),
                                Text(
                                  BooksMapping.bibleDivisionNameFromCode(bibleDivisionCode),
                                  style: TextStyle(
                                    color: context.theme.appColors.primary,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                            PhosphorIcon(
                              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                              color: context.theme.appColors.primary,
                              size: 18.0,
                              semanticLabel: 'Caret right',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: context.theme.appColors.appbarBackground,
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        PhosphorIcon(
                          PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.regular),
                          color: context.theme.appColors.primaryOnDark,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'RECENT',
                          style: TextStyle(
                            color: context.theme.appColors.primaryOnDark,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7.0),
                    SizedBox(
                      height: 50,
                      child: viewModel.recentBooks.isNotEmpty
                          ? GridView.builder(
                              itemCount: viewModel.recentBooks.length,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 120,
                                childAspectRatio: 4 / 2,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                String bookCode = viewModel.recentBooks.elementAt(index);
                                return InkWell(
                                  borderRadius: BorderRadius.circular(12.0),
                                  onTap: () => viewModel.onTapRecentBookItem(bookCode),
                                  child: Center(
                                    child: Text(
                                      BooksMapping.bookNameFromBookCode(bookCode),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: context.theme.appColors.primaryOnDark,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Text(
                                'Your recent books will appear here.',
                                style: TextStyle(
                                  color: context.theme.appColors.secondaryOnDark,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  NavigationBibleDivisionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NavigationBibleDivisionsViewModel(readerArea: readerArea);
}
