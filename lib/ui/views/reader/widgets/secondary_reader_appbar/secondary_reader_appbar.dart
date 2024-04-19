import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/enums.dart';
import '../reader_selector_btn/reader_selector_btn.dart';
import 'secondary_reader_appbar_model.dart';

class SecondaryReaderAppbar extends StackedView<SecondaryReaderAppbarModel> {
  const SecondaryReaderAppbar({
    super.key,
    required this.currentBook,
    required this.currentBibleVersion,
    required this.onTapBook,
    required this.onTapBibleVersion,
    required this.onTapClose,
  });

  final String currentBook;
  final String currentBibleVersion;
  final Function() onTapBook;
  final Function() onTapBibleVersion;
  final Function() onTapClose;

  @override
  Widget builder(
    BuildContext context,
    SecondaryReaderAppbarModel viewModel,
    Widget? child,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      color: Color(0xff161718),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 36,
            height: 29,
          ),
          ReaderSelectorBtn(
            areaType: Area.secondary,
            isActive: false,
            currentBook: currentBook,
            currentBibleVersion: currentBibleVersion,
            onTapBook: onTapBook,
            onTapBibleVersion: onTapBibleVersion,
          ),
          InkWell(
            onTap: onTapClose,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
              child: PhosphorIcon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                color: Colors.white,
                size: 20.0,
                semanticLabel: 'Close',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  SecondaryReaderAppbarModel viewModelBuilder(
    BuildContext context,
  ) =>
      SecondaryReaderAppbarModel();
}