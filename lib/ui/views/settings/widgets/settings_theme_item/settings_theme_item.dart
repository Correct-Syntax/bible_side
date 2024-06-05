import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/enums.dart';
import '../../../../../common/themes.dart';
import 'settings_theme_item_model.dart';

class SettingsThemeItem extends StackedView<SettingsThemeItemModel> {
  const SettingsThemeItem({
    super.key,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  final bool isSelected;
  final CurrentTheme theme;
  final Function() onTap;

  @override
  Widget builder(
    BuildContext context,
    SettingsThemeItemModel viewModel,
    Widget? child,
  ) {
    return InkWell(
      onTap: onTap,
      radius: 7.0,
      child: Container(
        width: 100.0,
        height: 134.0,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 7.0),
        decoration: BoxDecoration(
          color: viewModel.getBackgroundColor(theme),
          border: Border.all(color: context.theme.appColors.divider),
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Column(
          children: [
            Text(
              viewModel.getThemeName(theme),
              style: TextStyle(
                color: viewModel.getForegroundColor(theme),
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            Divider(
              height: 1.0,
              endIndent: 15.0,
              color: viewModel.getForegroundColor(theme),
            ),
            const SizedBox(height: 12.0),
            Divider(
              height: 1.0,
              endIndent: 35.0,
              color: viewModel.getForegroundColor(theme),
            ),
            const SizedBox(height: 12.0),
            Divider(
              height: 1.0,
              endIndent: 23.0,
              color: viewModel.getForegroundColor(theme),
            ),
            const SizedBox(height: 16.0),
            if (isSelected)
              PhosphorIcon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
                color: viewModel.getForegroundColor(theme),
                size: 27.0,
              ),
          ],
        ),
      ),
    );
  }

  @override
  SettingsThemeItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsThemeItemModel();
}
