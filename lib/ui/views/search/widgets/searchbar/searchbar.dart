import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import 'searchbar_model.dart';

class Searchbar extends StackedView<SearchbarModel> {
  const Searchbar({super.key});

  @override
  Widget builder(
    BuildContext context,
    SearchbarModel viewModel,
    Widget? child,
  ) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        prefixIcon: PhosphorIcon(
          PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
          color: Colors.white,
          size: 18.0,
          semanticLabel: 'Search',
        ),
        prefixIconColor: Colors.white54,
        filled: true,
        fillColor: Color(0xff222B2E),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff222B2E)),
          borderRadius: BorderRadius.circular(100.00),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffffffff)),
          borderRadius: BorderRadius.circular(100.00),
        ),
        hintText: 'Type to search...',
        hintStyle: TextStyle(
          color: Colors.white54,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  SearchbarModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchbarModel();
}
