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
import '../wordlinks/wordlinks_view.dart';

class ReaderViewModel extends ReactiveViewModel {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
  bool get showMarks => _settingsService.showMarks;
  bool get showChaptersAndVerses => _settingsService.showChaptersAndVerses;

  bool get showSecondaryArea => _settingsService.showSecondaryArea;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  List<String> get bookmarks => _settingsService.bookmarks;

  ReaderViewModel({required this.context});

  final BuildContext context;

  late WebViewController webviewController;

  bool isPrimaryReaderAreaPopupActive = false;
  bool isSecondaryReaderAreaPopupActive = false;
  bool isTopAppBarVisible = true;

  Future<void> initilize() async {
    setBusy(true);
    await setupWebviewController();
    await _biblesService.reloadBiblesJson();

    String primaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.primary,
      viewBy,
      primaryAreaBible,
      bookCode,
      bookmarks,
      showMarks,
      showChaptersAndVerses,
    );

    String secondaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.secondary,
      viewBy,
      secondaryAreaBible,
      bookCode,
      bookmarks,
      showMarks,
      showChaptersAndVerses,
    );

    await initilizeReaderWebview(
      primaryAreaHTML,
      secondaryAreaHTML,
      showSecondaryArea,
      linkReaderAreaScrolling,
    );
    setBusy(false);
  }

//JS injected after page load
  static const String _contextMenuJs = r"""
    // Disable native context menu
    document.addEventListener('contextmenu', e => e.preventDefault());

    // Detect long press / selection
    document.addEventListener('selectionchange', () => {
      const selection = window.getSelection();
      const text = selection.toString().trim();
      if (text.length > 0) {
        SelectionChannel.postMessage(text);
      }
    });
  """;
// JS injected after page loads
  static const String _wordClickJs = r"""
    (function() {
      if (window.__wordListenerAttached) return;
      window.__wordListenerAttached = true;

      let touchStartX = 0;
      let touchStartY = 0;

      document.addEventListener('touchstart', function(e) {
        if (e.touches && e.touches.length > 0) {
          touchStartX = e.touches[0].clientX;
          touchStartY = e.touches[0].clientY;
        }
      });

      function handleWordClick(e) {
        const touch = e.changedTouches ? e.changedTouches[0] : e;
        
        if (e.type === 'touchend' && e.changedTouches) {
          const deltaX = Math.abs(touch.clientX - touchStartX);
          const deltaY = Math.abs(touch.clientY - touchStartY);
          if (deltaX > 10 || deltaY > 10) {
            return; // Abort because user was scrolling
          }
        }

        let range;

        if (document.caretPositionFromPoint) {
          const pos = document.caretPositionFromPoint(touch.clientX, touch.clientY);
          if (!pos) return;
          range = document.createRange();
          range.setStart(pos.offsetNode, pos.offset);
        } else if (document.caretRangeFromPoint) {
          range = document.caretRangeFromPoint(touch.clientX, touch.clientY);
        }

        if (!range || range.startContainer.nodeType !== Node.TEXT_NODE) return;

        let targetElement = range.startContainer.parentElement;
        if (!targetElement || !targetElement.closest('[data-version="OET-LV"]')) return;

        range.expand('word');
        const word = range.toString().trim().replace(/[^a-zA-Z0-9']/g, '');

        if (word.length > 0) {
          let p = range.startContainer.parentElement ? range.startContainer.parentElement.closest('.p') : null;
          if (!p) return;
          let sup = p.querySelector('sup');
          if (!sup || !sup.id) return;

          let idParts = sup.id.split('-');
          if (idParts.length < 4) return;
          
          let book = idParts[1];
          let chapter = parseInt(idParts[2]);
          let verse = parseInt(idParts[3]);

          let preRange = document.createRange();
          try {
            if (sup.nextSibling) {
              preRange.setStartBefore(sup.nextSibling);
            } else {
              preRange.setStartAfter(sup);
            }
            preRange.setEnd(range.startContainer, range.startOffset);
          } catch (err) {
            return;
          }
          
          let preText = preRange.toString();
          let wordMatches = preText.match(/[a-zA-Z0-9']+/g);
          let wordNumber = (wordMatches ? wordMatches.length : 0) + 1;

          let payload = JSON.stringify({
             word: word,
             book: book,
             chapter: chapter,
             verse: verse,
             wordNumber: wordNumber
          });

          if (window.__wordClickTimeout) clearTimeout(window.__wordClickTimeout);
          window.__wordClickTimeout = setTimeout(() => {
            OnClickWordEvent.postMessage(payload);
          }, 250);
        }
      }

      document.addEventListener('mouseup', handleWordClick);
      document.addEventListener('touchend', handleWordClick);
    })();
  """;

  Future<void> setupWebviewController() async {
    PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();
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
      ..addJavaScriptChannel(
        'OnScrollEvent',
        onMessageReceived: (message) async {
          log('<OnScrollEvent> ${message.message}');
          try {
            final data = jsonDecode(message.message);
            final rawId = data['id'] ?? message.message;
            final cleaned =
                rawId.replaceAll('primary-', '').replaceAll('secondary-', '');
            final parts = cleaned.split('-');
            if (parts.length >= 3) {
              final chap = int.tryParse(parts[1]) ?? chapterNumber;
              final verse = int.tryParse(parts[2]) ?? verseNumber;
              _biblesService.setChapter(chap);
              _biblesService.setVerse(verse);
            } else if (parts.length == 2) {
              final chap = int.tryParse(parts[1]) ?? chapterNumber;
              _biblesService.setChapter(chap);
            }
          } catch (e) {
            final rawId = message.message;
            final cleaned =
                rawId.replaceAll('primary-', '').replaceAll('secondary-', '');
            final parts = cleaned.split('-');
            if (parts.length >= 3) {
              final chap = int.tryParse(parts[1]) ?? chapterNumber;
              final verse = int.tryParse(parts[2]) ?? verseNumber;
              _biblesService.setChapter(chap);
              _biblesService.setVerse(verse);
            }
          }
          rebuildUi();
        },
      )
      ..addJavaScriptChannel('OnScrollDirection',
          onMessageReceived: (message) async {
        // message.message expected to be 'down' or 'up'
        // print('||||hello from OnScrollDirection JavaScript channel!');
        // print('||||scroll direction message received: ' + message.message);
        if (message.message == 'down') {
          isTopAppBarVisible = false;
          rebuildUi();
        } else if (message.message == 'up') {
          isTopAppBarVisible = true;
          rebuildUi();
        }
      })
      ..addJavaScriptChannel(
        'OnClickWordEvent',
        onMessageReceived: (JavaScriptMessage message) {
          final word = message.message;
          _onWordTapped(word);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            rebuildUi();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            //This code is to add wordlinks to every OET-LV word, needs tweaked
            webviewController.runJavaScript(_wordClickJs);
            //webviewController.runJavaScript(_contextMenuJs);
          },
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
            final uri = Uri.parse(request.url);
            if (uri.scheme == 'app') {
              _handleAppNavigation(uri);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    await AndroidWebViewController.enableDebugging(true);

    webviewController.addJavaScriptChannel(
      'SelectionChannel',
      onMessageReceived: (message) {
        final selectedText = message.message;
        _showContextMenu(selectedText);
      },
    );
    /*
    * Conditionally add javascript channels. This is not possible to do inline witht he ..addJavaScriptChannle.
    * We need to add the channels based on the version. 
    * E.g. moo
    */
    /*
    if (1==1) {
  webviewController.addJavaScriptChannel(
    'WordChannel',
    onMessageReceived: (message) => _onWordTapped(message.message),
  );
  */
  }

  void _showContextMenu(String text) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Wordlink'),
              onTap: () {
                Navigator.pop(context);
                //_defineWord(text);
                print('Define: $text');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: text));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                //_shareText(text);
                print("Share $text");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onWordTapped(String message) {
    try {
      final data = jsonDecode(message);
      _navigationService.navigateTo(
        Routes.wordLinksView,
        arguments: WordLinksViewArguments(
          bookCode: data['book'],
          chapterNumber: data['chapter'],
          verseNumber: data['verse'],
          wordNumber: data['wordNumber'],
        ),
      );
    } catch (e) {
      log('Error parsing word click data: $e');
    }
  }

  void _handleAppNavigation(Uri uri) {
    final path = uri.pathSegments.first;

    switch (path) {
      case 'WordLinksView':
        /*
        _navigationService.navigateTo(
          Routes.wordLinksView,
          arguments: const WordLinksViewArguments(
            bookCode: 'ACT',
            chapterNumber: 1,
            verseNumber: 1,
            wordNumber: 1,
          ),
        );
        */
        break;
    }
  }

  /// Initializes the webview html with everything except for the reader area contents.
  Future<void> initilizeReaderWebview(
      String primaryAreaHTML,
      String secondaryAreaHTML,
      bool showSecondaryArea,
      bool linkReaderAreaScrolling) async {
    // Load font
    ByteData fontData = await rootBundle
        .load('assets/fonts/Merriweather/Merriweather-Regular.ttf');
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
    <div id="secondaryReader" class="scrollable" data-version="$secondaryAreaBible" >
      $secondaryAreaHTML
    </div>

    <hr class="separator" />

    <div id="primaryReader" class="scrollable" data-version="$primaryAreaBible">
      $primaryAreaHTML
    </div>
  </div>

  <script>
    document.body.className = 'hidden';
    // console.log('||||hello from initilizeReaderWebview function (in script) in ReaderViewModel!');

    var elements = null;
    var handleScroll = null;

    document.addEventListener("DOMContentLoaded", () => {
      const container = document.getElementById("container");
      elements = [...container.querySelectorAll(".scrollable")];

      var lastScrollTop = 0;
      // console.log('||||last scrollTop variable initialized: ' + lastScrollTop);

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

        // determine if pass a section header and if so, send a message to Flutter to display the section header in the top app bar
        // console.log('||||e.target:' + e.target);
        const sectionHeaders = scrolledEle.getElementsByClassName('section-box');

        // determine scroll direction and notify Flutter
        try {
          const cur = scrolledEle.scrollTop || 0;
          const last = lastScrollTop || 0;
          const delta = cur - last;
          lastScrollTop = cur;
          if (delta > 10) {
            OnScrollDirection.postMessage('down');
          } else if (delta < -10) {
            OnScrollDirection.postMessage('up');
          }
        } catch (e) {
          // ignore
        }

        // determine the top-visible verse id inside the scrolled reader area and notify Flutter
        try {
          // console.log('||||hello from handleScroll function in ReaderViewModel!');
          // console.log('||||scrolled element id: ' + scrolledEle.id);
          const areaPrefix = scrolledEle.id === 'primaryReader' ? 'primary-' : 'secondary-';
          function getTopVisibleId(container, prefix) {
            const items = container.querySelectorAll('[id^="' + prefix + '"]');
            let topId = null;
            let minOffset = Infinity;
            const cRect = container.getBoundingClientRect();
            items.forEach((it) => {
              const r = it.getBoundingClientRect();
              const offset = r.top - cRect.top;
              if (offset >= -10 && offset < minOffset) {
                minOffset = offset;
                topId = it.id;
              }
            });
            return topId;
          }

          const topId = getTopVisibleId(scrolledEle, areaPrefix);
          if (topId) {
            try {
              OnScrollEvent.postMessage(JSON.stringify({
                area: scrolledEle.id === 'primaryReader' ? 'primary' : 'secondary',
                id: topId
              }));
              // console.log('||||topId:' + topId);
              // console.log('||||message posted to OnScrollEvent channel with topId');
              // console.log('||||message content: ' + JSON.stringify({
              //   area: scrolledEle.id === 'primaryReader' ? 'primary' : 'secondary',
              //   id: topId
              // }));
            } catch (err) {
              // ignore posting errors
            }
          }
        } catch (err) {
          // ignore any errors computing top id
        }
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

    document.addEventListener("dblclick", function(event) {
      if (window.__wordClickTimeout) {
        clearTimeout(window.__wordClickTimeout);
        window.__wordClickTimeout = null;
      }

      if (window.getSelection().toString().length > 0) return;
      
      let target = event.target;
      let p = target.closest('.p');
      if (p) {
        if (p.hasAttribute('ondblclick')) {
          // Handled by inline attribute for backwards compatibility on other bibles
          return;
        }
        
        let verseId = null;
        if (p.id) {
          // For bibles that place ID directly on the paragraph
          verseId = p.id;
        } else {
          // For OET bibles that place ID on the superscript
          let sup = p.querySelector('sup[id]');
          if (sup && sup.id) {
            verseId = sup.id;
          }
        }
        
        if (verseId) {
          onCreateBookmark(verseId);
        }
      }
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
    return Uri.dataFromBytes(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            mimeType: mime)
        .toString();
  }

  Future<void> updateReaderAreaHTMLContent(
      Area area, String htmlContent) async {
    String areaId;
    if (area == Area.primary) {
      areaId = 'primaryReader';
    } else {
      areaId = 'secondaryReader';
    }
    // jsonEncode produces a properly escaped JS string literal (quotes, newlines,
    // backslashes all safely escaped) so we can assign it directly.
    final encoded = jsonEncode(htmlContent);
    await webviewController.runJavaScript(
        'document.getElementById("$areaId").innerHTML = $encoded;');
    rebuildUi();
  }

  Future<void> jumpToHTMLId(String id) async {
    await webviewController
        .runJavaScript('document.getElementById("$id").scrollIntoView();');
  }

  Future<void> toggleSecondaryAreaHTML(bool showSecondaryArea) async {
    if (showSecondaryArea == false) {
      await webviewController.runJavaScript(
          'document.getElementById("container").classList.add("hidden");');
    } else {
      await webviewController.runJavaScript(
          'document.getElementById("container").classList.remove("hidden");');
    }
  }

  Future<void> toggleLinkedScrollingHTML(bool linkScrolling) async {
    if (linkScrolling == true) {
      await webviewController.runJavaScript(
          'elements.forEach((ele) => {ele.addEventListener("scroll", handleScroll);});');
    } else {
      await webviewController.runJavaScript(
          'elements.forEach((ele) => {ele.removeEventListener("scroll", handleScroll);});');
    }
  }

  Future<void> updateReaderAreas() async {
    setBusy(true);
    await _biblesService.reloadBiblesJson();

    String primaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.primary,
      viewBy,
      primaryAreaBible,
      bookCode,
      bookmarks,
      showMarks,
      showChaptersAndVerses,
    );
    await updateReaderAreaHTMLContent(Area.primary, primaryAreaHTML);
    if (showSecondaryArea == true) {
      String secondaryAreaHTML = await _readerService.getReaderBookHTML(
        Area.secondary,
        viewBy,
        secondaryAreaBible,
        bookCode,
        bookmarks,
        showMarks,
        showChaptersAndVerses,
      );
      await updateReaderAreaHTMLContent(Area.secondary, secondaryAreaHTML);
    }

    log('$bookCode$chapterNumber');
    await jumpToHTMLId('$bookCode${chapterNumber.toString()}');
    setBusy(false);
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
    // Save ids without a specific reader area identifier.
    bookmarkId =
        bookmarkId.replaceAll('primary-', '').replaceAll('secondary-', '');

    // Update the icons in both reader areas.
    await webviewController.runJavaScript('''
      function textToHslColor(str) {
        if (!str || str.length === 0) return 'hsl(0, 0%, 0%)';
        var hash = 0;
        for (var i = 0; i < str.length; i++) {
          hash = str.charCodeAt(i) + ((hash << 5) - hash);
        }
        return 'hsl(' + (hash % 360) + ', 80%, 54%)';
      }

      var svgElements = [...document.getElementsByClassName("$bookmarkId-svg")];
      if (svgElements.length > 0) {
        svgElements.forEach(ele => ele.remove());
      } else {
        var hsl = textToHslColor("$bookmarkId");
        var svgStr = `<svg class="svg $bookmarkId-svg bookmarked" style="fill: ` + hsl + ` !important;" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 256 256"><path d="M184,32H72A16,16,0,0,0,56,48V224a8,8,0,0,0,12.24,6.78L128,193.43l59.77,37.35A8,8,0,0,0,200,224V48A16,16,0,0,0,184,32Zm0,177.57-51.77-32.35a8,8,0,0,0-8.48,0L72,209.57V48H184Z"></path></svg>`;
        
        ['primary', 'secondary'].forEach(area => {
          var targetId = area + "-$bookmarkId";
          var el = document.getElementById(targetId);
          if (el) {
            if (el.tagName.toLowerCase() === 'sup') {
              el.insertAdjacentHTML('beforebegin', svgStr);
            } else {
              el.insertAdjacentHTML('afterbegin', svgStr);
            }
          }
        });
      }
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
    log("ON TAP CLOSE SECONDARY AREA");
    onToggleSecondaryArea();
    isPrimaryReaderAreaPopupActive = false;
    isSecondaryReaderAreaPopupActive = false;
    log('close secondary area');
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

  Future<void> onEnableSecondaryArea() async {
    await _settingsService.setSecondaryAreaBible('OET-LV');
    await _settingsService.setShowSecondaryArea(true);
    await toggleSecondaryAreaHTML(true);
    // Full reload so the secondary area content renders correctly.
    await onChangeTranslationInline(Area.secondary, 'OET-LV');
  }

  void onToggleSecondaryArea() async {
    _settingsService.setShowSecondaryArea(!showSecondaryArea);
    await toggleSecondaryAreaHTML(showSecondaryArea);
    rebuildUi();
  }

  void onToggleLinkedScrolling() async {
    _settingsService.setLinkReaderAreaScrolling(!linkReaderAreaScrolling);
    await toggleLinkedScrollingHTML(linkReaderAreaScrolling);
    showToastMsg(linkReaderAreaScrolling == true
        ? 'Scrolling is linked'
        : 'Scrolling is unlinked');
    rebuildUi();
  }

  Future<void> onChangeTranslationInline(Area area, String translation) async {
    setBusy(true);
    if (area == Area.primary) {
      await _settingsService.setPrimaryAreaBible(translation);
    } else {
      await _settingsService.setSecondaryAreaBible(translation);
    }

    // Full reload using the same path as initialization — most reliable approach.
    await _biblesService.reloadBiblesJson();

    String primaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.primary,
      viewBy,
      primaryAreaBible,
      bookCode,
      bookmarks,
      showMarks,
      showChaptersAndVerses,
    );

    String secondaryAreaHTML = await _readerService.getReaderBookHTML(
      Area.secondary,
      viewBy,
      secondaryAreaBible,
      bookCode,
      bookmarks,
      showMarks,
      showChaptersAndVerses,
    );

    await initilizeReaderWebview(
      primaryAreaHTML,
      secondaryAreaHTML,
      showSecondaryArea,
      linkReaderAreaScrolling,
    );

    setBusy(false);
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_settingsService, _biblesService];
}
