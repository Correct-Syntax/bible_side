import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bibles_viewmodel.dart';

class BiblesView extends StackedView<BiblesViewModel> {
  const BiblesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    BiblesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  BiblesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      BiblesViewModel();
}
