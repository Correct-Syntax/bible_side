import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/themes.dart';

import 'wordlinks_viewmodel.dart';

class WordLinksView extends StackedView<WordLinksViewModel> {
  final int chapterNumber = 1;
  final int verseNumber = 2;
  final int wordNumber = 1;

  String get path => 'ACTc${chapterNumber}v${verseNumber}w$wordNumber';

  const WordLinksView({
    super.key,
  });

  @override
  void onViewModelReady(WordLinksViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize('https://freely-given.org/OBD/ref/GrkWrd/$path.htm');
  }

  @override
  Widget builder(
    BuildContext context,
    WordLinksViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: context.theme.appColors.background,
      appBar: AppBar(
        title: Text(
          'Greek Word',
          style: TextStyle(
            color: context.theme.appColors.primary,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: context.theme.appColors.background,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.theme.appColors.primary),
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: viewModel.webviewController,
            ),
            if (viewModel.isBusy)
              Center(
                child: CircularProgressIndicator(
                  color: context.theme.appColors.loadingSpinner,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  WordLinksViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      WordLinksViewModel(context: context);
}
