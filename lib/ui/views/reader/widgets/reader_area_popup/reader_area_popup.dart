import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/bibles.dart';
import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';
import '../../../../common/ui_helpers.dart';
import 'reader_area_popup_model.dart';

class ReaderAreaPopup extends StackedView<ReaderAreaPopupModel> {
  const ReaderAreaPopup({
    super.key,
    required this.readerArea,
    required this.onToggleSecondaryArea,
    required this.onToggleLinkedScrolling,
  });

  final Area readerArea;
  final Function() onToggleSecondaryArea;
  final Function() onToggleLinkedScrolling;

  @override
  Widget builder(
    BuildContext context,
    ReaderAreaPopupModel viewModel,
    Widget? child,
  ) {
    bool isWideLayout = shouldSwitchToWideLayout(context);
    return Container(
      height: 200.0,
      color: context.theme.appColors.popupBackground,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
      child: Column(
        children: [
          Opacity(
            opacity: viewModel.showSecondaryArea ? 1.0 : 0.5,
            child: InkWell(
              onTap: viewModel.showSecondaryArea ? viewModel.onChangeSecondaryBibleVersion : onToggleSecondaryArea,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        RotatedBox(
                          quarterTurns: isWideLayout ? -1 : 0,
                          child: Stack(
                            children: [
                              PhosphorIcon(
                                PhosphorIcons.squareSplitVertical(PhosphorIconsStyle.regular),
                                color: context.theme.appColors.primaryOnDark,
                                size: 22.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                                child: Container(
                                  width: 14.0,
                                  height: 7.0,
                                  color: context.theme.appColors.primaryOnDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  viewModel.secondaryBible,
                                  style: TextStyle(
                                    color: context.theme.appColors.primaryOnDark,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: context.theme.appColors.readerSelectorBackground,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Text(
                                    viewModel.showSecondaryArea ? 'Secondary' : 'Tap to enable',
                                    style: TextStyle(
                                      color: viewModel.showSecondaryArea
                                          ? context.theme.appColors.primaryOnDark.withAlpha(220)
                                          : context.theme.appColors.primaryOnDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${bibleVersionsMapping[viewModel.secondaryBible]}',
                              style: TextStyle(
                                color: context.theme.appColors.primaryOnDark.withAlpha(180),
                                fontSize: 10.0,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    PhosphorIcon(
                      PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                      color: context.theme.appColors.primaryOnDark,
                      size: 18.0,
                      semanticLabel: 'Caret down',
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onToggleLinkedScrolling,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhosphorIcon(
                viewModel.linkReaderAreaScrolling
                    ? PhosphorIcons.linkSimpleHorizontal(PhosphorIconsStyle.regular)
                    : PhosphorIcons.linkSimpleHorizontalBreak(PhosphorIconsStyle.regular),
                color: context.theme.appColors.primaryOnDark,
                size: 22.0,
                semanticLabel: 'Link',
              ),
            ),
          ),
          InkWell(
            onTap: readerArea == Area.primary
                ? viewModel.onChangePrimaryBibleVersion
                : viewModel.onChangeSecondaryBibleVersion,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RotatedBox(
                        quarterTurns: isWideLayout ? 3 : 0,
                        child: Stack(
                          children: [
                            PhosphorIcon(
                              PhosphorIcons.squareSplitVertical(PhosphorIconsStyle.regular),
                              color: context.theme.appColors.primaryOnDark,
                              size: 22.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0, left: 4.0),
                              child: Container(
                                width: 14.0,
                                height: 7.0,
                                color: context.theme.appColors.primaryOnDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                viewModel.primaryBible,
                                style: TextStyle(
                                  color: context.theme.appColors.primaryOnDark,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                decoration: BoxDecoration(
                                  color: context.theme.appColors.readerSelectorBackground,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text(
                                  'Primary',
                                  style: TextStyle(
                                    color: context.theme.appColors.primaryOnDark.withAlpha(220),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${bibleVersionsMapping[viewModel.primaryBible]}',
                            style: TextStyle(
                              color: context.theme.appColors.primaryOnDark.withAlpha(180),
                              fontSize: 10.0,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  PhosphorIcon(
                    PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                    color: context.theme.appColors.primaryOnDark,
                    size: 18.0,
                    semanticLabel: 'Caret down',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ReaderAreaPopupModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderAreaPopupModel();
}
