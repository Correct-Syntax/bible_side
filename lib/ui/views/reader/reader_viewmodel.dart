import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../common/themes.dart';
import '../../../common/toast.dart';
import '../../../services/bibles_service.dart';
import '../../../services/reader_service.dart';
import '../../../services/settings_service.dart';

class ReaderViewModel extends ReactiveViewModel {
  final _biblesService = locator<BiblesService>();
  final _readerService = locator<ReaderService>();
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();

  String get primaryAreaBible => _settingsService.primaryBible;
  String get secondaryAreaBible => _settingsService.secondaryBible;
  String get bookCode => _biblesService.bookCode;
  int get chapterNumber => _biblesService.chapterNumber;
  int get verseNumber => _biblesService.verseNumber;

  ViewBy get viewBy => _biblesService.viewBy;

  double get textScaling => _settingsService.textScaling;
  bool get showSecondaryArea => _settingsService.showSecondaryArea;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  ReaderViewModel({required this.context});

  final BuildContext context;

  late WebViewController webviewController;

  bool isPrimaryReaderAreaPopupActive = false;
  bool isSecondaryReaderAreaPopupActive = false;

  void initilize() async {
    await setupWebviewController();
    await _biblesService.reloadBiblesJson();

    String primaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.primary,
      viewBy,
      primaryAreaBible,
      bookCode,
    );
    String secondaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.secondary,
      viewBy,
      secondaryAreaBible,
      bookCode,
    );

    await initilizeReaderWebview(
      primaryAreaHTML,
      secondaryAreaHTML,
      showSecondaryArea,
      linkReaderAreaScrolling,
    );
  }

  Future<void> setupWebviewController() async {
    PlatformWebViewControllerCreationParams params = const PlatformWebViewControllerCreationParams();
    webviewController = WebViewController.fromPlatformCreationParams(params)
      ..setBackgroundColor(context.theme.appColors.background)
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'OnDoubleClickVerseEvent',
        onMessageReceived: (message) async {
          log('<OnDoubleClickVerseEvent> ${message.message}');
          await setBookmark(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            rebuildUi();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {
            log('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    AndroidWebViewController.enableDebugging(true);
  }

  /// Initilizes the webview html with everything except for the reader area contents.
  Future<void> initilizeReaderWebview(
      String primaryAreaHTML, String secondaryAreaHTML, bool showSecondaryArea, bool linkReaderAreaScrolling) async {
    // Load font
    ByteData fontData = await rootBundle.load('assets/fonts/Merriweather/Merriweather-Regular.ttf');
    String fontUri = getFontUri(fontData, 'font/truetype').toString();

    // Theme
    if (!context.mounted) return;
    var theme = getThemeManager(context).selectedThemeIndex;
    String themeName = CurrentTheme.light.name;
    switch (theme) {
      case 0:
        themeName = CurrentTheme.light.name;
      case 1:
        themeName = CurrentTheme.dark.name;
      case 2:
        themeName = CurrentTheme.sepia.name;
      case 3:
        themeName = CurrentTheme.contrast.name;
    }

    // When scrolling is linked, only ``primaryScrollToId`` is used
    // so that even with different contents lengths the primary reader
    // area will still be scrolled to the right place.
    String scrollToId = '$bookCode-$chapterNumber-$verseNumber';
    String primaryScrollToId = 'primary-$scrollToId';
    String secondaryScrollToId = 'secondary-$scrollToId';

    log('Primary ID->: $primaryScrollToId | Secondary ID->: $secondaryScrollToId');

    Uri htmlUri = Uri.dataFromString("""
<!DOCTYPE html>
<html lang="en">
<head>
  <title></title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
</head>
<body class="$themeName">
  <style>
    :root {
      /* Mirrors colors from themes.dart */
      --red-letter: #C24545;
      --add-article: #CB9169;
      --add-extra: #5EC651;
      --add-copula: #C260B1;

      --light-theme-white: #fff;
      --light-theme-white-70: rgba(255, 255, 255, 0.7);
      --light-theme-light-blue: #DAEDFC;
      --light-theme-medium-blue: #1F3D57;
      --light-theme-dark-blue: #193247;
      --light-theme-medium-slate: #515358;
      --light-theme-medium-slate-10: rgba(81, 83, 88, 0.1);
      --light-theme-medium-dark-slate: #414548;

      --dark-theme-white: #fff;
      --dark-theme-white-10: rgba(255, 255, 255, 0.1);
      --dark-theme-white-70: rgba(255, 255, 255, 0.7);
      --dark-theme-medium-light-gray: #A9ADB1;
      --dark-theme-dark-gray: #1F2123;
      --dark-theme-almost-black: #161718;

      --sepia-theme-white: #fff;
      --sepia-theme-almost-white-tan: #FBF8E9;
      --sepia-theme-light-tan: #EBDFC7;
      --sepia-theme-medium-brown: #8E8367;
      --sepia-theme-medium-dark-brown: #655F49;
      --sepia-theme-medium-gray: #5E6166;
      --sepia-theme-medium-dark-gray: #414546;

      --contrast-theme-white: #fff;
      --contrast-theme-black: #000;
    }

    @font-face {
      font-family: 'Merriweather';
      src: url('$fontUri');
    }

    body.hidden {
      opacity: 0;
    }

    body.visible {
      opacity: 1;
      transition: opacity 1s ease-out;
    }

    body.light {
      color: var(--light-theme-medium-slate); 
      background-color: var(--light-theme-white);
    }

    body.dark {
      color: var(--dark-theme-medium-light-gray);
      background-color: var(--dark-theme-dark-gray);
    }

    body.sepia {
      color: var(--sepia-theme-medium-gray);
      background-color: var(--sepia-theme-almost-white-tan);
    }

    body.contrast {
      color: var(--contrast-theme-white);
      background-color: var(--contrast-theme-black);
    }

    #primaryReader {
      font-family: 'Merriweather';
      font-size: ${0.9 * textScaling}rem;
      letter-spacing: 0.3px;
      line-height: 155%;
      height: 50vh;
      padding-top: 0.3rem;
      margin-left: 1rem;
      margin-right: 1rem;
    }

    #secondaryReader {
      font-family: 'Merriweather';
      font-size: ${0.9 * textScaling}rem;
      letter-spacing: 0.3px;
      line-height: 155%;
      height: 50vh;
      margin-left: 1rem;
      margin-right: 1rem;
    }

    .container {
      display: flex;
      flex-direction: column;
      max-height: 100vh;
      margin: 0;
    }

    .container.hidden #primaryReader {
      height: 100vh;
    }

    .container.hidden #secondaryReader {
      height: 0px;
      display: none;
    }

    .container.hidden .separator {
      display: none;
    }

    .scrollable {
      overflow: auto;
    }

    hr {
      margin-top: 8px;
      margin-bottom: 8px;
      width: 100%;
    }

    .light hr {
      border-color: var(--light-theme-medium-slate-10)
    }

    .dark hr {
      border-color: var(--dark-theme-white-10)
    }

    .sepia hr {
      border-color: var(--sepia-theme-light-tan)
    }

    .contrast hr {
      border-color: var(--contrast-theme-white)
    }

    p.p {
      margin-top: 0.2rem;
      margin-bottom: 0.2rem;
    }

    .svg {
      visibility: hidden !important;
      display: inline-block !important;
    }

    .svg.bookmarked {
      visibility: visible !important;
      fill: black !important;
    }

    sup {
      font-size: ${0.6 * textScaling}rem;
      margin-left: 0.0rem;
      margin-right: 0.0rem;
    }

    .c {
      font-size: ${1.6 * textScaling}rem;
      margin-right: 0.1rem;
      margin-left: 0.0rem;
    }

    a {
      color: blue;
    }

    .section-box {
      float: right;
      width: 40%;
      border-width: 2px;
      border-style: solid;
      padding: 0.2rem;
      font-size: ${0.8 * textScaling}rem;
      font-weight: bold;
      line-height: normal;
      padding: 0.6rem;
      margin-left: 0.3rem;
      border-radius: 2px;
    }

    .section-box sup {
      font-size: ${0.6 * textScaling}rem;
      margin-left: 0rem;
      margin-right: 0.0rem;
    }

    .section-box p {
      display: inline-block;
      line-height: normal;
      margin: 0px;
    }

    .light .section-box {
      border-color: var(--light-theme-medium-slate-10);
    }

    .dark .section-box {
      border-color: var(--dark-theme-medium-light-gray);
    }

    .sepia .section-box {
      border-color: var(--sepia-theme-medium-gray);
    }

    .contrast .section-box {
      border-color: var(--contrast-theme-white);
    }

    @media screen and (min-width: 500px) {
      .container {
        flex-direction: row;
      }
      #primaryReader {
        width: 50vw;
        height: 100vh;
        padding-top: 0.1rem;
      }
      #secondaryReader {
        width: 50vw;
        height: 100vh;
        padding-top: 0.1rem;
      }
      hr {
        height: 100vh;
        max-width: 0.5px;
        margin-top: 0px;
        margin-bottom: 0px;
      }
    }
  </style>

  <div class="container ${showSecondaryArea == false ? "hidden" : ""}" id="container">
    <div id="secondaryReader" class="scrollable">
      $secondaryAreaHTML
    </div>

    <hr class="separator" />

    <div id="primaryReader" class="scrollable">
      $primaryAreaHTML
    </div>
  </div>

  <script>
    document.body.className = 'hidden';

    var elements = null;
    var handleScroll = null;
    document.addEventListener("DOMContentLoaded", () => {
      const container = document.getElementById("container");
      elements = [...container.querySelectorAll(".scrollable")];

      const syncScroll = (scrolledEle, ele) => {
        const scrolledPercent = scrolledEle.scrollTop / (scrolledEle.scrollHeight - scrolledEle.clientHeight);
        const top = scrolledPercent * (ele.scrollHeight - ele.clientHeight);

        const scrolledWidthPercent = scrolledEle.scrollLeft / (scrolledEle.scrollWidth - scrolledEle.clientWidth);
        const left = scrolledWidthPercent * (ele.scrollWidth - ele.clientWidth);

        ele.scrollTo({
          behavior: "instant",
          top,
          left,
        });
      };

      handleScroll = (e) => {
        const scrolledEle = e.target;
        elements.filter((item) => item !== scrolledEle).forEach((ele) => {
          ele.removeEventListener("scroll", handleScroll);
          syncScroll(scrolledEle, ele);
          window.requestAnimationFrame(() => {
            ele.addEventListener("scroll", handleScroll);
          });
        });
      };
      
      ${linkReaderAreaScrolling == true ? """
        elements.forEach((ele) => {
          ele.addEventListener("scroll", handleScroll);
        });
      """ : ""}

      document.getElementById("$primaryScrollToId").scrollIntoView();
      ${linkReaderAreaScrolling == false ? """
        document.getElementById("$secondaryScrollToId").scrollIntoView();
      """ : ""}

      document.body.className = '$themeName visible';
    });

    function onCreateBookmark(bookmark) {
      OnDoubleClickVerseEvent.postMessage(bookmark);
    }
  </script>
</body>
</html>
""", mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));

    await webviewController.loadRequest(htmlUri);

    rebuildUi();
  }

  String getFontUri(ByteData data, String mime) {
    final buffer = data.buffer;
    return Uri.dataFromBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), mimeType: mime).toString();
  }

  Future<void> updateReaderAreaHTMLContent(Area area, String htmlContent) async {
    String areaId;
    if (area == Area.primary) {
      areaId = 'primaryReader';
    } else {
      areaId = 'secondaryReader';
    }
    await webviewController.runJavaScript('document.getElementById("$areaId").innerHTML = "$htmlContent";');
    rebuildUi();
  }

  Future<void> jumpToHTMLId(String id) async {
    await webviewController.runJavaScript('document.getElementById("$id").scrollIntoView();');
  }

  Future<void> toggleSecondaryAreaHTML(bool showSecondaryArea) async {
    if (showSecondaryArea == false) {
      await webviewController.runJavaScript('document.getElementById("container").classList.add("hidden");');
    } else {
      await webviewController.runJavaScript('document.getElementById("container").classList.remove("hidden");');
    }
  }

  Future<void> toggleLinkedScrollingHTML(bool linkScrolling) async {
    if (linkScrolling == true) {
      await webviewController
          .runJavaScript('elements.forEach((ele) => {ele.addEventListener("scroll", handleScroll);});');
    } else {
      await webviewController
          .runJavaScript('elements.forEach((ele) => {ele.removeEventListener("scroll", handleScroll);});');
    }
  }

  Future<void> updateReaderAreas() async {
    await _biblesService.reloadBiblesJson();

    String primaryAreaHTML = await _readerService.getReaderBookHTML(Area.primary, viewBy, primaryAreaBible, bookCode);
    await updateReaderAreaHTMLContent(Area.primary, primaryAreaHTML);
    if (showSecondaryArea == true) {
      String secondaryAreaHTML =
          await _readerService.getReaderBookHTML(Area.secondary, viewBy, secondaryAreaBible, bookCode);
      await updateReaderAreaHTMLContent(Area.secondary, secondaryAreaHTML);
    }

    log('$bookCode$chapterNumber');
    await jumpToHTMLId('$bookCode${chapterNumber.toString()}');
  }

  void onRefreshDebug() async {
    await updateReaderAreas();
  }

  @override
  void dispose() {
    webviewController.clearCache();
    super.dispose();
  }

  Future<void> setBookmark(String bookmarkId) async {
    // Save ids without a specific reader area indentifier.
    bookmarkId = bookmarkId.replaceAll('primary-', '').replaceAll('secondary-', '');

    // Update the icons in both reader areas.
    await webviewController.runJavaScript('''
      var svgElements = [...document.getElementsByClassName("$bookmarkId-svg")];

      svgElements.forEach((ele) => {
        ele.classList.toggle("bookmarked");
      });
    ''');

    List<String> existingBookmarks = await _settingsService.getBookmarks();

    // If the bookmark already exists, remove it.
    if (existingBookmarks.contains(bookmarkId)) {
      existingBookmarks.remove(bookmarkId);
    } else {
      existingBookmarks.add(bookmarkId);
    }
    await _settingsService.setBookmarks(existingBookmarks);
    rebuildUi();
  }

  void setChapter(dynamic chapter) {
    if (chapter is String) {
      _biblesService.setChapter(int.parse(chapter));
    } else if (chapter is int) {
      _biblesService.setChapter(chapter);
    }
    rebuildUi();
  }

  void onTapCloseSecondaryArea() async {
    onToggleSecondaryArea();
    isPrimaryReaderAreaPopupActive = false;
    isSecondaryReaderAreaPopupActive = false;
    rebuildUi();
  }

  void onTapBook(Area area) {
    _navigationService.clearStackAndShow(
      Routes.navigationBibleDivisionsView,
      arguments: NavigationBibleDivisionsViewArguments(readerArea: area),
    );
  }

  void onTapBibleVersion(Area? area) {
    if (area == Area.primary) {
      isPrimaryReaderAreaPopupActive = !isPrimaryReaderAreaPopupActive;
      isSecondaryReaderAreaPopupActive = false;
    } else if (area == Area.secondary) {
      isSecondaryReaderAreaPopupActive = !isSecondaryReaderAreaPopupActive;
      isPrimaryReaderAreaPopupActive = false;
    } else {
      isPrimaryReaderAreaPopupActive = false;
      isSecondaryReaderAreaPopupActive = false;
    }
    rebuildUi();
  }

  void onTapSearch() {
    _navigationService.clearStackAndShow(Routes.searchView);
  }

  void onToggleSecondaryArea() async {
    _settingsService.setShowSecondaryArea(!showSecondaryArea);
    await toggleSecondaryAreaHTML(showSecondaryArea);
    rebuildUi();
  }

  void onToggleLinkedScrolling() async {
    _settingsService.setLinkReaderAreaScrolling(!linkReaderAreaScrolling);
    await toggleLinkedScrollingHTML(linkReaderAreaScrolling);
    showToastMsg(linkReaderAreaScrolling == true ? 'Scrolling is linked' : 'Scrolling is unlinked');
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settingsService, _biblesService];
}
