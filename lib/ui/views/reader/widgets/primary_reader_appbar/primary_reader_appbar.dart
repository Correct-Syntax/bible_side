import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';
import '../reader_selector_btn/reader_selector_btn.dart';
import 'primary_reader_appbar_model.dart';

class PrimaryReaderAppbar extends StackedView<PrimaryReaderAppbarModel> {
  const PrimaryReaderAppbar({
    super.key,
    required this.isReaderAreaPopupActive,
    required this.onTapSearch,
    required this.onTapBook,
    required this.onTapBibleVersion,
    required this.onTapMenu,
  });

  final bool isReaderAreaPopupActive;
  final Function() onTapSearch;
  final Function() onTapBook;
  final Function() onTapBibleVersion;
  final Function() onTapMenu;

  @override
  Widget builder(
    BuildContext context,
    PrimaryReaderAppbarModel viewModel,
    Widget? child,
  ) {
    return SafeArea(
      child: Container(
        color: context.theme.appColors.appbarBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onTapSearch,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PhosphorIcon(
                  PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
                  color: context.theme.appColors.appbarIcon,
                  size: 20.0,
                  semanticLabel: 'Search',
                ),
              ),
            ),
            ReaderSelectorBtn(
              readerArea: Area.primary,
              isActive: isReaderAreaPopupActive,
              onTapBook: onTapBook,
              onTapBibleVersion: onTapBibleVersion,
            ),
            InkWell(
              onTap: onTapMenu,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PhosphorIcon(
                  PhosphorIcons.list(PhosphorIconsStyle.bold),
                  color: context.theme.appColors.appbarIcon,
                  size: 20.0,
                  semanticLabel: 'Menu',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PrimaryReaderAppbarModel viewModelBuilder(
    BuildContext context,
  ) =>
      PrimaryReaderAppbarModel();
}
