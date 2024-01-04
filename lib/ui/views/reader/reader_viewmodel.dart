import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../services/bibles_service.dart';
import '../../../services/reader_service.dart';
import '../../../services/side_navigation_service.dart';

class ReaderViewModel extends ReactiveViewModel {
  final _sideNavigationService = locator<SideNavigationService>();
  final _biblesService = locator<BiblesService>();
  final _readerService = locator<ReaderService>();

  int get currentIndex => _sideNavigationService.currentIndex;

  String get topBibleCode => _biblesService.topBibleCode;
  String get bookCode => _biblesService.bookCode;
  int get chapter => _biblesService.chapter;

  ReaderViewModel({required this.context});

  final BuildContext context;

  PagingController<int, Map<String, dynamic>> pagingController = PagingController(
    firstPageKey: 1,
  );

  //List<TextSpan> versesList = List.generate(30, (index) => TextSpan(text: '$index\n\n'));

  Future<void> initilize() async {}

  void setCurrentIndex(int index) {
    _sideNavigationService.setCurrentIndex(index);
    rebuildUi();
  }

  void setChapter(dynamic chapter) {
    if (chapter.runtimeType == String) {
      _biblesService.setChapter(int.parse(chapter));
    } else {
      _biblesService.setChapter(chapter);
    }
    rebuildUi();
  }

  List<Map<String, dynamic>> getPaginatedVerses(int pageKey) {
    return _readerService.getPaginatedVerses(pageKey, context);
  }

  String getcurrentBookName() {
    return _biblesService.bookCodeToBook(bookCode);
  }

  String getcurrentNavigationString(String bookCode, int chapter) {
    final navStr = '${_biblesService.bookCodeToBook(bookCode)} $chapter';
    return navStr;
  }

  void updateInterface() {
    pagingController.notifyListeners();
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_biblesService];
}
