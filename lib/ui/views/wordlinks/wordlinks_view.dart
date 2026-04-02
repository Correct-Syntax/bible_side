import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/themes.dart';

import 'wordlinks_viewmodel.dart';

class WordLinksView extends StackedView<WordLinksViewModel> {
  final String bookCode;
  final int chapterNumber;
  final int verseNumber;
  final int wordNumber;

  String get path => '${bookCode}c${chapterNumber}v${verseNumber}w$wordNumber';

  const WordLinksView({
    super.key,
    required this.bookCode,
    required this.chapterNumber,
    required this.verseNumber,
    required this.wordNumber,
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
        child: viewModel.showInternetAccess
            ? Stack(
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
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Internet access is disabled. Please enable it in Settings to view word links.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.theme.appColors.primary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: viewModel.navigateToSettings,
                        child: const Text('Go to Settings'),
                      ),
                    ],
                  ),
                ),
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
