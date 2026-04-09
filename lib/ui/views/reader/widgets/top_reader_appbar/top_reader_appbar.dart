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
    required this.book,
    required this.chapter,
    required this.verse,
    required this.primaryVersion,
    required this.secondaryVersion,
  });

  bool isReaderAreaPopupActive;
  final Function() onTapBook;
  final Function() onTapBibleVersion;
  String book;
  int chapter;
  int verse;
  String primaryVersion;
  String? secondaryVersion;

  @override
  Widget builder(
    BuildContext context,
    TopReaderAppbarModel viewModel,
    Widget? child,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: context.theme.appColors.appbarBackground,
          ),
          child: Center(
            child: Text(
              viewModel.getSectionPrimaryORSecondary(primaryVersion, secondaryVersion, book, chapter, verse),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15.0,
                color: context.theme.appColors.primaryOnDark,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  TopReaderAppbarModel viewModelBuilder(
    BuildContext context,
  ) =>
      TopReaderAppbarModel();
}
