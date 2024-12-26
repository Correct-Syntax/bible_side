import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/themes.dart';
import 'toggle_item_model.dart';

class ToggleItem extends StackedView<ToggleItemModel> {
  const ToggleItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget builder(
    BuildContext context,
    ToggleItemModel viewModel,
    Widget? child,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.theme.appColors.primary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            activeColor: context.theme.appColors.background,
            activeTrackColor: context.theme.appColors.switchBackground,
            inactiveThumbColor: context.theme.appColors.primary,
            inactiveTrackColor: context.theme.appColors.background,
            trackOutlineColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return context.theme.appColors.switchBackground;
              }
              return context.theme.appColors.primary;
            }),
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  ToggleItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      ToggleItemModel();
}
