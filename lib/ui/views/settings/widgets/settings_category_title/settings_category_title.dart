import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/themes.dart';
import 'settings_category_title_model.dart';

class SettingsCategoryTitle extends StackedView<SettingsCategoryTitleModel> {
  const SettingsCategoryTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget builder(
    BuildContext context,
    SettingsCategoryTitleModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, bottom: 6.0, left: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: context.theme.appColors.secondary,
          fontWeight: FontWeight.w500,
          fontSize: 12.0,
          letterSpacing: -0.1,
        ),
      ),
    );
  }

  @override
  SettingsCategoryTitleModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsCategoryTitleModel();
}
