import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../common/themes.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../services/settings_service.dart';
import '../../../services/json_service.dart';
import 'package:stacked_services/stacked_services.dart';

class WordLinksViewModel extends BaseViewModel {
  final BuildContext context;
  final _settingsService = locator<SettingsService>();
  final _navigationService = locator<NavigationService>();
  final _jsonService = locator<JsonService>();

  late final WebViewController webviewController;

  bool get showInternetAccess => _settingsService.showInternetAccess;

  WordLinksViewModel({required this.context});

  void navigateToSettings() {
    //_navigationService.navigateTo(Routes.settingsView, preventDuplicates: true);
    _navigationService.clearStackAndShow(Routes.settingsView);
  }

  String? _extractFromText(String rawVerseText, int wordNumber) {
    bool showSpecialMarks = _settingsService.showMarks;

    String processed = rawVerseText
        .replaceAll(RegExp(r'untr.*?untr\* ?'), '')
        .replaceAll(RegExp(r' +'), ' ')
        .replaceAll('>', '')
        .replaceAll('=', ' ')
        .replaceAll("'", "’");

    if (!showSpecialMarks) {
      processed = processed.replaceAll('_', ' ');
    }

    String tokenized = processed.replaceAllMapped(
        RegExp(r'¦([0-9]+)'), (m) => '《${m.group(1)}》');

    RegExp wordExp = RegExp(r"([\p{L}\p{N}’'\-_《》]+)", unicode: true);
    var matches = wordExp.allMatches(tokenized).toList();

    if (wordNumber > 0 && wordNumber <= matches.length) {
      String block = matches[wordNumber - 1].group(1)!;
      RegExp parseExp = RegExp(r"《(\d+)》");
      var parseMatches = parseExp.allMatches(block);
      if (parseMatches.isNotEmpty) {
        return parseMatches.last.group(1);
      }
    }
    return null;
  }

  Future<String?> _getParsingNumber(
      Map<String, dynamic> json, int chapter, int verse, int wordNumber) async {
    if (json['content'] == null) {
      if (json['chapters'] != null &&
          chapter > 0 &&
          chapter <= json['chapters'].length) {
        Map chapterData = json['chapters'][chapter - 1];
        if (chapterData['verses'] != null &&
            verse > 0 &&
            verse <= chapterData['verses'].length) {
          Map verseData = chapterData['verses'][verse - 1];
          String rawText = verseData['text'] ?? '';
          return _extractFromText(rawText, wordNumber);
        }
      }
      return null;
    }

    String currentChapter = '1';
    bool inTargetVerse = false;
    String rawVerseText = '';

    for (var item in json['content']) {
      if (item['type'] == 'chapter') {
        if (inTargetVerse) {
          return _extractFromText(rawVerseText, wordNumber);
        }
        currentChapter = item['number'];
        inTargetVerse = false;
      }
      if (currentChapter != chapter.toString()) continue;

      if (item['type'] == 'para') {
        for (var contentItem in item['content'] ?? []) {
          if (contentItem is Map) {
            if (contentItem['type'] == 'verse') {
              if (inTargetVerse) {
                return _extractFromText(rawVerseText, wordNumber);
              }
              if (contentItem['number'] == verse.toString()) {
                inTargetVerse = true;
                rawVerseText = '';
              }
            } else if (contentItem['type'] == 'char' && inTargetVerse) {
              for (var charItem in contentItem['content'] ?? []) {
                if (charItem is String) rawVerseText += charItem;
              }
            }
          } else if (contentItem is String && inTargetVerse) {
            rawVerseText += contentItem;
          }
        }
      }
    }

    if (inTargetVerse && rawVerseText.isNotEmpty) {
      return _extractFromText(rawVerseText, wordNumber);
    }
    return null;
  }

  Future<void> initialize(String bookCode, int chapterNumber, int verseNumber,
      int wordNumber) async {
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

            Color bgColor = Theme.of(context).appColors.background;
            Color primaryColor = Theme.of(context).appColors.primary;

            String bgCss =
                'rgba(${(bgColor.r * 255.0).round().clamp(0, 255)}, ${(bgColor.g * 255.0).round().clamp(0, 255)}, ${(bgColor.b * 255.0).round().clamp(0, 255)}, ${bgColor.a})';
            String primaryCss =
                'rgba(${(primaryColor.r * 255.0).round().clamp(0, 255)}, ${(primaryColor.g * 255.0).round().clamp(0, 255)}, ${(primaryColor.b * 255.0).round().clamp(0, 255)}, ${primaryColor.a})';

            // Define your custom CSS rules here
            String cssString = '''
              body { background-color: $bgCss !important; color: $primaryCss !important; padding: 16px; font-family: system-ui, -apple-system, sans-serif; }
              .header { display: none !important; }
              .site { display: none !important; }
              .card { display: flex; flex-direction: column; gap: 8px; }
              .title { font-size: 26px; font-weight: bold; margin-bottom: 12px; color: $primaryCss; }
              .row { font-size: 16px; line-height: 1.5; }
              .label { font-weight: bold; opacity: 0.8; margin-right: 4px; }
              .morph { margin-top: 16px; font-size: 14px; opacity: 0.9; }
              .glossHelper { font-style: italic; opacity: 0.7; }
              .glossPre { font-style: italic; opacity: 0.7; }
              .ul { text-decoration: underline; }
              pre { display: none; }
            ''';

            // Inject the CSS into the page via JavaScript
            webviewController.runJavaScript('''
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = `$cssString`;
              document.head.appendChild(style);
              
              function renderData(data) {
                var greek_word = data.Greek_word || data.actual_word || '';
                var transliteration = data.transliterated_Greek_word || '';
                var word_role = data.word_role || '';
                var word_number = data.word_number || '';
                var gloss = data.OET_gloss_words || data.word_gloss || '';
                var strongs = data.Strongs_number || data.Strongs || '';
                var lemma = data.Greek_lemma || '';
                
                function decodeHtml(html) {
                  var txt = document.createElement("textarea");
                  txt.innerHTML = html;
                  return txt.value;
                }

                var morphHtml = data.tidy_morphology_html ? decodeHtml(data.tidy_morphology_html) : '';
                var transHtml = data.translation_html ? decodeHtml(data.translation_html) : '';
                
                var html = '<div class="card">';
                if (greek_word) html += '<div class="title">' + greek_word + '</div>';
                if (word_number) html += '<div class="row"><span class="label">Wordlink: #</span> ' + word_number + '</div>';
                if (transliteration) html += '<div class="row"><span class="label">'+greek_word+'</span> ' + transliteration + '</div>';
                if (transHtml) html += '<div>' + transHtml + '</div>';
                if (word_role) html += '<div class="row"><span class="label">Word Role:</span> ' + word_role + '</div>';
                if (gloss) html += '<div class="row"><span class="label">Gloss:</span> ' + gloss + '</div>';
                if (strongs) html += '<div class="row"><span class="label">Strong\\'s:</span> ' + strongs + '</div>';
                if (lemma) html += '<div class="row"><span class="label">Lemma:</span> ' + lemma + '</div>';
                if (morphHtml) html += '<div class="morph">' + morphHtml + '</div>';
               
                html += '</div>';
                
                document.body.innerHTML = html;
              }

              try {
                var pre = document.querySelector('pre');
                var jsonText = pre ? pre.textContent : document.body.innerText;
                var data = JSON.parse(jsonText);
                renderData(data);
              } catch(e) {
                fetch(window.location.href)
                  .then(res => res.json())
                  .then(data => renderData(data))
                  .catch(err => console.error("Failed to parse JSON fetch", err));
              }
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
      );

    String path = '${bookCode}c${chapterNumber}v${verseNumber}w$wordNumber';

    String url = '';

    try {
      final json = await _jsonService.loadBookJson('OET-LV', bookCode);
      String? parsingNumber =
          await _getParsingNumber(json, chapterNumber, verseNumber, wordNumber);
      if (parsingNumber != null && parsingNumber.isNotEmpty) {
        if (BooksMapping.isOldTestament(bookCode)) {
          url = 'https://freely-given.org/OBD/app/HebWrd/$parsingNumber.json';
        } else {
          url = 'https://freely-given.org/OBD/app/GrkWrd/$parsingNumber.json';
        }
      } else {
        log("Parsing Number is missing");
      }
    } catch (e) {
      log('Error extracting parsing number: $e');
    }
    log("Loading JSON wordlink: $url");
    webviewController.loadRequest(Uri.parse(url));
  }
}
