import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'reader_navigation_viewmodel.dart';

class ReaderNavigationView extends StackedView<ReaderNavigationViewModel> {
  const ReaderNavigationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ReaderNavigationViewModel viewModel,
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
  ReaderNavigationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReaderNavigationViewModel();
}
