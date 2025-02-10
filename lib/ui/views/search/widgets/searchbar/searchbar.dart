import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/themes.dart';
import 'searchbar_model.dart';

class Searchbar extends StackedView<SearchbarModel> {
  const Searchbar({
    super.key,
    required this.onSearch,
  });

  final Function(String) onSearch;

  @override
  Widget builder(
    BuildContext context,
    SearchbarModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          prefixIcon: PhosphorIcon(
            PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
            color: context.theme.appColors.primary,
            size: 18.0,
            semanticLabel: 'Search',
          ),
          prefixIconColor: context.theme.appColors.primary,
          filled: true,
          fillColor: context.theme.appColors.inputBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.appColors.inputBorder),
            borderRadius: BorderRadius.circular(100.00),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.theme.appColors.primary),
            borderRadius: BorderRadius.circular(100.00),
          ),
          hintText: 'Search…',
          hintStyle: TextStyle(
            color: context.theme.appColors.secondary,
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        onSubmitted: (value) => onSearch(value),
      ),
    );
  }

  @override
  SearchbarModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchbarModel();
}
