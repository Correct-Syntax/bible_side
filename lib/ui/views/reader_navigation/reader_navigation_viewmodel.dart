import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../common/mappings.dart';
import '../../../common/oet_rv_sections.dart';
import '../../../services/bibles_service.dart';


class ReaderNavigationViewModel extends BaseViewModel {
  final _biblesService = locator<BiblesService>();
  final _navigationService = locator<NavigationService>();

  String get bookCode => _biblesService.bookCode;
  ViewBy get viewBy => _biblesService.viewBy;

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

  Future<void> onTapBookItem(int index) async {
    _biblesService.setBookCode(bookMapping.keys.elementAt(index));

    // Generate list of chapters
    int numOfChapters = bookNumOfChaptersMapping.values.firstWhere((element) => element == bookNumOfChaptersMapping[bookCode]);
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

    if (viewBy == ViewBy.chapter) {

    } else if (viewBy == ViewBy.section) {
      
    }

    _navigationService.navigateToReaderView();
    await _biblesService.reloadBiblesJson();
  }

  Future<void> onTapSectionItem(int index) async {

    
    _navigationService.navigateToReaderView();
    await _biblesService.reloadBiblesJson();
  }
}
