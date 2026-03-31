import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/themes.dart';

class WordLinksViewModel extends BaseViewModel {
  final BuildContext context;
  late final WebViewController webviewController;

  WordLinksViewModel({required this.context});

  void initialize(String url) {
    setBusy(true);

    PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();
    webviewController = WebViewController.fromPlatformCreationParams(params)
      ..setBackgroundColor(context.theme.appColors.background)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setBusy(false);
            }
          },
          onPageStarted: (String url) {
            setBusy(true);
          },
          onPageFinished: (String url) {
            setBusy(false);

            final String background = Theme.of(context)
                .colorScheme
                .inverseSurface
                .hashCode
                .toString();

            // Define your custom CSS rules here
            String cssString = "body { background-color: " +
                background +
                " !important; color: " +
                Theme.of(context).colorScheme.primary.hashCode.toString() +
                " !important; }" +
                ".header { display: none !important; }" +
                ".site { display: none !important; }";

            // Inject the CSS into the page via JavaScript
            webviewController.runJavaScript('''
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = "$cssString";
              document.head.appendChild(style);
            ''');
          },
          onHttpError: (HttpResponseError error) {
            log('HTTP Error: ${error.request?.uri}');
            setBusy(false);
          },
          onWebResourceError: (WebResourceError error) {
            log('Web Resource Error: ${error.description}');
            setBusy(false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}
