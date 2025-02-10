import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/books.dart';
import '../../../../../common/themes.dart';
import '../../../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'search_result_item_model.dart';

class SearchResultItem extends StackedView<SearchResultItemModel> {
  const SearchResultItem({
    super.key,
    required this.bookCode,
    required this.chapter,
    required this.verse,
    required this.verseText,
    required this.onTap,
  });

  final String bookCode;
  final int chapter;
  final int verse;
  final String verseText;
  final Function() onTap;

  @override
  Widget builder(
    BuildContext context,
    SearchResultItemModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Column(
            spacing: 7.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BibleDivisionIndicator(
                            color: BooksMapping.colorFromBookCode(bookCode),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          viewModel.getReference(bookCode, chapter, verse),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: context.theme.appColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PhosphorIcon(
                    PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                    color: context.theme.appColors.primary,
                    size: 16.0,
                    semanticLabel: 'Caret right',
                  ),
                ],
              ),
              Text(
                verseText,
                style: TextStyle(
                  color: context.theme.appColors.secondary,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SearchResultItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchResultItemModel();
}
