import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../common/books.dart';
import '../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'navigation_bible_divisions_viewmodel.dart';

class NavigationBibleDivisionsView extends StackedView<NavigationBibleDivisionsViewModel> {
  const NavigationBibleDivisionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    NavigationBibleDivisionsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 26.0, left: 25.0, right: 25.0),
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
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
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
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          PhosphorIcon(
                            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                            color: Colors.white,
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
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 7.0),
              child: Row(
                children: [
                  PhosphorIcon(
                    PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.regular),
                    color: Colors.white,
                    size: 18.0,
                    semanticLabel: 'Caret right',
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'RECENT',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 67,
              child: GridView.builder(
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
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  NavigationBibleDivisionsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NavigationBibleDivisionsViewModel();
}
