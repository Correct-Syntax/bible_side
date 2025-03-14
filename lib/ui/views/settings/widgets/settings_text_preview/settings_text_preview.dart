import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../../common/themes.dart';
import '../../../../common/ui_helpers.dart';
import 'settings_text_preview_model.dart';

class SettingsTextPreview extends StackedView<SettingsTextPreviewModel> {
  const SettingsTextPreview({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsTextPreviewModel viewModel,
    Widget? child,
  ) {
    bool isPortrait = isPortraitOrientation(context);
    return Container(
      width: isPortrait ? 300.0 : 500.0,
      height: 120.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: context.theme.appColors.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: context.theme.appColors.divider),
      ),
      child: SingleChildScrollView(
        child: RichText(
          textScaler: TextScaler.linear(viewModel.textScaling),
          text: TextSpan(
            style: TextStyle(
              color: context.theme.appColors.readerText,
              fontFamily: 'Merriweather',
              fontSize: 16.0,
              letterSpacing: 0.3,
              height: 1.6,
            ),
            children: const [
              TextSpan(
                text: '1 ',
                style: TextStyle(fontSize: 26.0),
              ),
              TextSpan(
                text: 'In the beginning was the message, and the message was with God, and the message was and is God.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SettingsTextPreviewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SettingsTextPreviewModel();
}
