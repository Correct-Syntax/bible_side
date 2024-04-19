import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'reader_translation_popup_model.dart';

class ReaderTranslationPopup extends StackedView<ReaderTranslationPopupModel> {
  const ReaderTranslationPopup({super.key});

  @override
  Widget builder(
    BuildContext context,
    ReaderTranslationPopupModel viewModel,
    Widget? child,
  ) {
    return const SizedBox.shrink();
  }

  @override
  ReaderTranslationPopupModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderTranslationPopupModel();
}
