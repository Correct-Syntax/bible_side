import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/books.dart';
import '../../../../../common/themes.dart';
import '../../../../widgets/common/bible_division_indicator/bible_division_indicator.dart';
import 'search_filter_item_model.dart';

class SearchFilterItem extends StackedView<SearchFilterItemModel> {
  const SearchFilterItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onSelected,
  });

  final String item;
  final bool isSelected;
  final Function(String?) onSelected;

  @override
  Widget builder(
    BuildContext context,
    SearchFilterItemModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: () => onSelected(item),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(40.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
        margin: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: context.theme.appColors.filterItemBackground,
          border: Border.all(
            width: 1.0,
            color: isSelected == true ? context.theme.appColors.primary : Colors.transparent,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Row(
          spacing: 4.0,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 13.0),
                child: BibleDivisionIndicator(
                  color: BooksMapping.colorFromSectionCode(item),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                BooksMapping.sectionNameFromSectionCode(item),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: context.theme.appColors.primary,
                ),
              ),
            ),
            if (isSelected)
              PhosphorIcon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                color: context.theme.appColors.primary,
                size: 12.0,
                semanticLabel: 'Caret right',
              ),
          ],
        ),
      ),
    );
  }

  @override
  SearchFilterItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchFilterItemModel();
}
