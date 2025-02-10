import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../search_filter_item/search_filter_item.dart';
import 'search_filter_bar_model.dart';

class SearchFilterBar extends StackedView<SearchFilterBarModel> {
  const SearchFilterBar({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChangeItem,
  });

  final String? selectedItem;
  final List<String> items;
  final Function(String?) onChangeItem;

  @override
  Widget builder(
    BuildContext context,
    SearchFilterBarModel viewModel,
    Widget? child,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 46.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String item = items[index];
                bool isSelected = selectedItem == item;
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 25.0 : 0.0),
                  child: SearchFilterItem(
                    item: item,
                    isSelected: isSelected,
                    onSelected: isSelected ? (i) => onChangeItem(null) : (i) => onChangeItem(i),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  SearchFilterBarModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchFilterBarModel();
}
