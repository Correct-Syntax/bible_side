import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/bibles.dart';
import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';

import 'reader_area_popup_model.dart';

class ReaderAreaPopup extends StackedView<ReaderAreaPopupModel> {
  const ReaderAreaPopup({
    super.key,
    required this.readerArea,
    required this.onClosePopup,
    required this.onSelectTranslation,
  });

  final Area readerArea;
  final Function() onClosePopup;
  final Function(String) onSelectTranslation;

  @override
  Widget builder(
    BuildContext context,
    ReaderAreaPopupModel viewModel,
    Widget? child,
  ) {
    return Container(
      color: context.theme.appColors.popupBackground,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              'Recent Translations',
              style: TextStyle(
                color: context.theme.appColors.primaryOnDark.withAlpha(150),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...viewModel.recentTranslations.map((translation) {
            final isSelected = readerArea == Area.primary
                ? viewModel.primaryBible == translation
                : viewModel.secondaryBible == translation;

            final isSelectedByOther = viewModel.showSecondaryArea &&
                !isSelected &&
                (readerArea == Area.primary
                    ? viewModel.secondaryBible == translation
                    : viewModel.primaryBible == translation);

            return InkWell(
              onTap: () {
                onSelectTranslation(translation);
                onClosePopup();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (isSelected || isSelectedByOther)
                      ? context.theme.appColors.readerSelectorBackground
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translation,
                          style: TextStyle(
                            color: context.theme.appColors.primaryOnDark,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.1,
                          ),
                        ),
                        Text(
                          '${bibleVersionsMapping[translation]}',
                          style: TextStyle(
                            color: context.theme.appColors.primaryOnDark
                                .withAlpha(180),
                            fontSize: 10.0,
                            letterSpacing: -0.1,
                          ),
                        ),
                      ],
                    ),
                    if (isSelected)
                      PhosphorIcon(
                        PhosphorIcons.check(PhosphorIconsStyle.bold),
                        color: context.theme.appColors.primaryOnDark,
                        size: 16.0,
                      )
                  ],
                ),
              ),
            );
          }).toList(),
          InkWell(
            onTap: () {
              viewModel.onChangeBibleVersion(readerArea);
              onClosePopup();
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'More...',
                    style: TextStyle(
                      color: context.theme.appColors.primaryOnDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PhosphorIcon(
                    PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                    color: context.theme.appColors.primaryOnDark,
                    size: 16.0,
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
