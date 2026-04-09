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
    this.onTapMenu,
    this.showLinkButton = false,
    this.linkReaderAreaScrolling = false,
    this.onToggleLinkedScrolling,
    this.onTapAddSecondary,
  });

  final bool isReaderAreaPopupActive;
  final Function() onTapSearch;
  final Function() onTapBook;
  final Function() onTapBibleVersion;
  final Function()? onTapMenu;
  final bool showLinkButton;
  final bool linkReaderAreaScrolling;
  final Function()? onToggleLinkedScrolling;
  final Function()? onTapAddSecondary;

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReaderSelectorBtn(
                  readerArea: Area.primary,
                  isActive: isReaderAreaPopupActive,
                  onTapBook: onTapBook,
                  onTapBibleVersion: onTapBibleVersion,
                ),
                if (onTapAddSecondary != null)
                  InkWell(
                    onTap: onTapAddSecondary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
                      child: PhosphorIcon(
                        PhosphorIcons.plus(PhosphorIconsStyle.bold),
                        color: context.theme.appColors.secondaryOnDark,
                        size: 20.0,
                        semanticLabel: 'Add secondary',
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showLinkButton && onToggleLinkedScrolling != null)
                  InkWell(
                    onTap: onToggleLinkedScrolling,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PhosphorIcon(
                        linkReaderAreaScrolling
                            ? PhosphorIcons.linkSimpleHorizontal(PhosphorIconsStyle.regular)
                            : PhosphorIcons.linkSimpleHorizontalBreak(PhosphorIconsStyle.regular),
                        color: context.theme.appColors.appbarIcon,
                        size: 22.0,
                        semanticLabel: 'Link',
                      ),
                    ),
                  ),
                if (onTapMenu != null)
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
                  )
                else
                  const SizedBox(width: 52.0),
              ],
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
