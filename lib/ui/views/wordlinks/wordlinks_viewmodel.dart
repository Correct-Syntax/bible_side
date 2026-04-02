import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/themes.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/settings_service.dart';
import 'package:stacked_services/stacked_services.dart';

class WordLinksViewModel extends BaseViewModel {
  final BuildContext context;
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  late final WebViewController webviewController;

  bool get showInternetAccess => _settingsService.showInternetAccess;

  WordLinksViewModel({required this.context});

  void navigateToSettings() {
    //_navigationService.navigateTo(Routes.settingsView, preventDuplicates: true);
    _navigationService.clearStackAndShow(Routes.settingsView);
  }

  void initialize(String url) {
    if (!showInternetAccess) {
      return;
    }

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
            String cssString = 'body { background-color: ' +
                background +
                ' !important; color: ' +
                Theme.of(context).colorScheme.primary.hashCode.toString() +
                ' !important; }' +
                '.header { display: none !important; }' +
                '.site { display: none !important; }';

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
