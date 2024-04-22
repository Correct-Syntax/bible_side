import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';
import '../reader_selector_btn/reader_selector_btn.dart';
import 'secondary_reader_appbar_model.dart';

class SecondaryReaderAppbar extends StackedView<SecondaryReaderAppbarModel> {
  const SecondaryReaderAppbar({
    super.key,
    required this.isReaderAreaPopupActive,
    required this.onTapBook,
    required this.onTapBibleVersion,
    required this.onTapClose,
  });

  final bool isReaderAreaPopupActive;
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
          ReaderSelectorBtn(
            readerArea: Area.secondary,
            isActive: isReaderAreaPopupActive,
            onTapBook: onTapBook,
            onTapBibleVersion: onTapBibleVersion,
          ),
          InkWell(
            onTap: onTapClose,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
              child: PhosphorIcon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                color: context.theme.appColors.secondaryOnDark,
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
