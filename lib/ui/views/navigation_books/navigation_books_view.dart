import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../common/books.dart';
import '../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'navigation_books_viewmodel.dart';

class NavigationBooksView extends StackedView<NavigationBooksViewModel> {
  const NavigationBooksView({
    Key? key,
    required this.bibleDivisionCode,
  }) : super(key: key);

  final String bibleDivisionCode;

  @override
  Widget builder(
    BuildContext context,
    NavigationBooksViewModel viewModel,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36.0),
            Expanded(
              child: ListView.builder(
                itemCount: BooksMapping.numOfBooksFromBibleDivisionCode(bibleDivisionCode),
                itemBuilder: (BuildContext context, int index) {
                  Map<String, String> booksMapping = BooksMapping.booksMappingFromBibleDivisionCode(bibleDivisionCode);
                  String key = booksMapping.keys.toList()[index];
                  return InkWell(
                    onTap: () => viewModel.onTapBookItem(key),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${booksMapping[key]}',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
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
          ],
        ),
      ),
    );
  }

  @override
  NavigationBooksViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NavigationBooksViewModel();
}
