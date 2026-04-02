import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';
import '../../reader_viewmodel.dart';
import '../reader_selector_btn/reader_selector_btn.dart';
import 'top_reader_appbar_model.dart';

class TopReaderAppbar extends StackedView<TopReaderAppbarModel> {
  TopReaderAppbar({
    super.key,
    this.isReaderAreaPopupActive = true,
    required this.onTapBook,
    required this.onTapBibleVersion,
    // required this.onTapClose,
    required this.chapter,
    required this.verse,
    // required this.viewModelReader,
  });

  bool isReaderAreaPopupActive;
  final Function() onTapBook;
  final Function() onTapBibleVersion;
  // final Function() onTapClose;
  int chapter;
  int verse;
  // ReaderViewModel viewModelReader; 
  // Function(int chapter, int verse) displaySectionHeader;

  @override
  Widget builder(
    BuildContext context,
    TopReaderAppbarModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      color: context.theme.appColors.appbarBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 36,
            height: 29,
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: context.theme.appColors.readerSelectorBackground,
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: Center(
              child: Text(
                '${chapter}:${verse}',  // TODO: make this update when scroll to new chapter/verse
                style: TextStyle(
                  fontSize: 15.0,
                  color: context.theme.appColors.primaryOnDark,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 36,
            height: 29,
          ),
        ],
      ),
    );
  }

  @override
  TopReaderAppbarModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopReaderAppbarModel();
}
