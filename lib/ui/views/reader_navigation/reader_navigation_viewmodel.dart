import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../common/books.dart';
import '../../../common/oet_rv_section_headings.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class ReaderNavigationViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();
  final _navigationService = locator<NavigationService>();

  String get bookCode => _settingsService.bookCode;
  List<String> get recentBooks => _settingsService.recentBooks;
  ViewBy get viewBy => _biblesService.viewBy;

  bool showBooksNavigation = true;
  bool showSectionNavigation = false;

  List<String> bookChapters = [];
  List<List<String>> sections = [];

  late TabController tabController;

  Future<void> initilize() async {
    tabController.addListener(() {
      _biblesService.setViewBy(tabController.index == 0 ? ViewBy.section : ViewBy.chapter);
    });
  }

  String getFirstSectionHeading(int index) {
    return sections[index][0];
  }

  Iterable<String> getAlternativeSectionHeadings(int index) {
    return sections[index].skip(1); // Skip the first section heading
  }

  Future<void> onTapBookItem(int index) async {
    String book = booksMapping.keys.elementAt(index);
    _biblesService.setBook(book);
    _biblesService.addBookToRecentHistory(book);

    // Generate list of chapters
    int numOfChapters =
        bookNumOfChaptersMapping.values.firstWhere((element) => element == bookNumOfChaptersMapping[bookCode]);
    bookChapters = [for (int i = 1; i <= numOfChapters; i++) i.toString()];

    // Generate sections
    sections = sectionHeadingsMappingForOET[bookCode]!;

    showBooksNavigation = false;
    showSectionNavigation = true;
    rebuildUi();
  }

  Future<void> onTapChapterItem(int index) async {
    log(index.toString());
    int chapter = int.parse(bookChapters[index]);
    _biblesService.setChapter(chapter);

    _navigationService.navigateToReaderView();
  }

  Future<void> onTapSectionItem(int index) async {
    String sectionHeading = sections[index][0];
    log(sectionHeading);

    // RegExp regex = RegExp(r'(\d*:\d*)');
    // String reference = regex.stringMatch(sectionHeading)!;
    // _biblesService.setSectionReference(reference.toString());
    _biblesService.setSection(index);

    // For bibles that do not have a by section implementation
    //_biblesService.setChapter();

    _navigationService.navigateToReaderView();
    await _biblesService.reloadBiblesJson();
  }
}
