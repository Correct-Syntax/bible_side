import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import '../../../../../common/books.dart';
import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';
import '../../../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'reader_selector_btn_model.dart';

class ReaderSelectorBtn extends StackedView<ReaderSelectorBtnModel> {
  const ReaderSelectorBtn({
    super.key,
    required this.readerArea,
    required this.isActive,
    required this.onTapBook,
    required this.onTapBibleVersion,
  });

  final Area readerArea;
  final bool isActive;
  final Function() onTapBook;
  final Function() onTapBibleVersion;

  @override
  Widget builder(
    BuildContext context,
    ReaderSelectorBtnModel viewModel,
    Widget? child,
  ) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: context.theme.appColors.readerSelectorBackground,
        borderRadius: BorderRadius.circular(60.0),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onTapBook,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 7.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 13.0),
                      child: BibleDivisionIndicator(
                        color: BooksMapping.colorFromBookCode(viewModel.bookCode),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      BooksMapping.bookNameFromBookCode(viewModel.bookCode),
                      style: TextStyle(
                        fontSize: 15.0,
                        color: context.theme.appColors.primaryOnDark,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
            child: VerticalDivider(
              color: context.theme.appColors.primaryOnDark.withAlpha(80),
              thickness: 1.0,
              width: 12.0,
            ),
          ),
          InkWell(
            onTap: onTapBibleVersion,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 7.0),
              child: Text(
                readerArea == Area.primary ? viewModel.primaryBible : viewModel.secondaryBible,
                style: TextStyle(
                  fontSize: 14.0,
                  color: context.theme.appColors.primaryOnDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ReaderSelectorBtnModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderSelectorBtnModel();
}
