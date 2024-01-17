import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../common/books.dart';
import '../../../common/oet_rv_sections.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class ReaderNavigationViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();
  final _navigationService = locator<NavigationService>();

  String get bookCode => _settingsService.bookCode;
  ViewBy get viewBy => _biblesService.viewBy;

  Map<String, String> get booksMapping => _biblesService.booksMapping;

  bool showBooksNavigation = true;
  bool showSectionNavigation = false;

  List<String> bookChapters = [];
  List<List<String>> sections = [];

  late TabController tabController;

  Future<void> initilize() async {
    tabController.addListener(() {
      _biblesService.setViewBy(tabController.index == 0 ? ViewBy.chapter : ViewBy.section);
    });
  }

  String getFirstSectionHeading(int index) {
    return sections[index][0];
  }

  Iterable<String> getAlternativeSectionHeadings(int index) {
    return sections[index].skip(1); // Skip the first section heading
  }

  Future<void> onTapBookItem(int index) async {
    _biblesService.setBook(booksMapping.keys.elementAt(index));

    // Generate list of chapters
    int numOfChapters =
        bookNumOfChaptersMapping.values.firstWhere((element) => element == bookNumOfChaptersMapping[bookCode]);
    bookChapters = [for (int i = 1; i <= numOfChapters; i++) i.toString()];

    // Generate sections
    sections = bookSectionNameMapping[bookCode]!;

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
    int sectionIndex = 1;
    _biblesService.setSection(sectionIndex);

    _navigationService.navigateToReaderView();
    await _biblesService.reloadBiblesJson();
  }
}
