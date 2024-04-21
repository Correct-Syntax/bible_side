import 'dart:developer';
import 'package:flutter/material.dart';

import '../app/app.locator.dart';
import '../common/enums.dart';
import '../common/oet_rv_section_start_end.dart';
import '../models/bibles/kjv_bible.dart';
import '../models/bibles/oet_lv_bible.dart';
import '../models/bibles/oet_rv_bible.dart';
import 'bibles_service.dart';
import 'settings_service.dart';

class ReaderService {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();

  Map<String, dynamic> get primaryAreaJson => _biblesService.primaryAreaJson;
  Map<String, dynamic> get secondaryAreaJson => _biblesService.secondaryAreaJson;

  String get primaryBible => _settingsService.primaryBible;
  String get secondaryBible => _settingsService.secondaryBible;
  String get bookCode => _settingsService.bookCode;

  ViewBy get viewBy => _biblesService.viewBy;

  /// A "Page" is a chapter in Chapter mode and a section in Section mode.
  /// An "Area" is the area in the reader where bible text is displayed and scrolled.

  /// Get a new page at [pageKey] for the current bible, book, etc and the given [Area].
  List<Map<String, dynamic>> getNewPage(BuildContext context, int pageKey, Area area) {
    if (area == Area.primary) {
      return pageFromJson(context, primaryAreaJson, primaryBible, viewBy, pageKey);
    } else if (area == Area.secondary) {
      return pageFromJson(context, secondaryAreaJson, secondaryBible, viewBy, pageKey);
    } else {
      return [];
    }
  }

  /// Get a page at [pageKey] that fits all of the given parameters.
  List<Map<String, dynamic>> pageFromJson(
      BuildContext context, Map<String, dynamic> json, String bibleCode, ViewBy viewBy, int pageKey) {
    Map<String, dynamic>? sectionReferences;
    if (viewBy == ViewBy.section) {
      sectionReferences = sectionStartEndMappingForOET[bookCode]?[pageKey];
    }

    if (bibleCode == 'OET-LV') {
      var bibleImpl = OETLiteralBibleImpl(context, json);
      switch (viewBy) {
        case ViewBy.section:
          if (sectionReferences == null) {
            return [];
          }
          return bibleImpl.getSection(pageKey, sectionReferences);
        case ViewBy.chapter:
          return bibleImpl.getChapter(pageKey);
        default:
          return [];
      }
    } else if (bibleCode == 'OET-RV') {
      var bibleImpl = OETReadersBibleImpl(context, json);
      switch (viewBy) {
        case ViewBy.section:
          if (sectionReferences == null) {
            return [];
          }
          List<Map<String, dynamic>> section = bibleImpl.getSection(pageKey, sectionReferences);
          return section;
        case ViewBy.chapter:
          List<Map<String, dynamic>> chapter = bibleImpl.getChapter(pageKey);
          return chapter;
        default:
          return [];
      }
    } else if (bibleCode == 'KJV') {
      var bibleImpl = KJVBibleImpl(context, json);
      return bibleImpl.getChapter(pageKey);
    } else {
      log('No bible found for bibleCode, $bibleCode');
      return [];
    }
  }
}
