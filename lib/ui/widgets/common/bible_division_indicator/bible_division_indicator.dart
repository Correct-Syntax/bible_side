import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bible_division_indicator_model.dart';

class BibleDivisionIndicator extends StackedView<BibleDivisionIndicatorModel> {
  const BibleDivisionIndicator({super.key});

  @override
  Widget builder(
    BuildContext context,
    BibleDivisionIndicatorModel viewModel,
    Widget? child,
  ) {
    return Container(
      width: 7.0,
      height: 7.0,
      decoration: BoxDecoration(
        color: Color(0xff074DFF),
        borderRadius: BorderRadius.circular(100.0),
      ),
    );
  }

  @override
  BibleDivisionIndicatorModel viewModelBuilder(
    BuildContext context,
  ) =>
      BibleDivisionIndicatorModel();
}
