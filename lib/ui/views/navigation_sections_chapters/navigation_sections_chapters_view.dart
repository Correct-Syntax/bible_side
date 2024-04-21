import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../common/books.dart';
import '../../common/ui_helpers.dart';
import '../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'navigation_sections_chapters_viewmodel.dart';

class NavigationSectionsChaptersView extends StackedView<NavigationSectionsChaptersViewModel> {
  const NavigationSectionsChaptersView({
    Key? key,
    required this.bookCode,
  }) : super(key: key);

  final String bookCode;

  @override
  void onViewModelReady(NavigationSectionsChaptersViewModel viewModel) async {
    await viewModel.initilize();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    NavigationSectionsChaptersViewModel viewModel,
    Widget? child,
  ) {
    bool isPortrait = isPortraitOrientation(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        title: isPortrait
            ? null
            : Text(
                BooksMapping.bookNameFromBookCode(bookCode),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: isPortrait ? 26.0 : 0.0, left: 25.0, right: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPortrait)
              Column(
                children: [
                  const Text(
                    'The book of',
                    style: TextStyle(
                      color: Colors.white54,
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
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36.0),
                ],
              ),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.sections.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => viewModel.onTapSectionItem(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.getFirstSectionHeading(index),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                for (String alternativeSection in viewModel.getAlternativeSectionHeadings(index))
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0, top: 2.0),
                                    child: Text(
                                      alternativeSection,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: PhosphorIcon(
                              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                              color: Colors.white,
                              size: 18.0,
                              semanticLabel: 'Caret right',
                            ),
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
      NavigationSectionsChaptersViewModel(bookCode: bookCode);
}
