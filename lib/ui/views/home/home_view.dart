import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../reader/reader_view.dart';
import '../settings/settings_view.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  Widget getViewForIndex(int index) {
    switch (index) {
      case 1:
        return const SettingsView();
      default:
        return const ReaderView();
    }
  }

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return getViewForIndex(viewModel.currentIndex);
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
