import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stacked/stacked.dart';

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
  final ThemeMode theme;
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
          color: theme == ThemeMode.light ? Colors.white : const Color(0xFF1F2123),
          border: Border.all(color: context.theme.appColors.divider),
          borderRadius: BorderRadius.circular(7.0),
        ),
        child: Column(
          children: [
            Text(
              theme == ThemeMode.light ? 'Light' : 'Dark',
              style: TextStyle(
                color: theme == ThemeMode.light ? const Color(0xFF515358) : Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10.0),
            Divider(
              height: 1.0,
              endIndent: 15.0,
              color: theme == ThemeMode.light ? const Color(0xFF515358) : Colors.white,
            ),
            const SizedBox(height: 12.0),
            Divider(
              height: 1.0,
              endIndent: 35.0,
              color: theme == ThemeMode.light ? const Color(0xFF515358) : Colors.white,
            ),
            const SizedBox(height: 12.0),
            Divider(
              height: 1.0,
              endIndent: 23.0,
              color: theme == ThemeMode.light ? const Color(0xFF515358) : Colors.white,
            ),
            const SizedBox(height: 16.0),
            if (isSelected)
              PhosphorIcon(
                PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
                color: theme == ThemeMode.light ? const Color(0xFF515358) : Colors.white,
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
