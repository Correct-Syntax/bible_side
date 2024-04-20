import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../common/books.dart';
import '../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'navigation_sections_chapters_viewmodel.dart';

class NavigationSectionsChaptersView extends StackedView<NavigationSectionsChaptersViewModel> {
  const NavigationSectionsChaptersView({
    Key? key,
    required this.bookCode,
  }) : super(key: key);

  final String bookCode;

  @override
  Widget builder(
    BuildContext context,
    NavigationSectionsChaptersViewModel viewModel,
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
            const Text(
              'The book of',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 13.0, right: 8),
                    child: BibleDivisionIndicator(
                      color: BooksMapping.colorFromBookCode(bookCode),
                    ),
                  ),
                ),
                Text(
                  BooksMapping.bookNameFromBookCode(bookCode),
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
                itemCount: 4,//viewModel.sections.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    //onTap: () => viewModel.onTapBookItem(key),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '1:1 (Test) Prophecies against Judah',
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
  NavigationSectionsChaptersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      NavigationSectionsChaptersViewModel();
}
