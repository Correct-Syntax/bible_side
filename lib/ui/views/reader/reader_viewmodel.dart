import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../common/enums.dart';
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

  late ScrollController topController;
  late ScrollController bottomController;
  late LinkedScrollControllerGroup parentController;

  bool showBottomSheet = true;

  PagingController<int, Map<String, dynamic>> topPagingController =
      PagingController(
    firstPageKey: 1,
  );

  PagingController<int, Map<String, dynamic>> bottomPagingController =
      PagingController(
    firstPageKey: 1,
  );

  Future<void> initilize() async {
    parentController = LinkedScrollControllerGroup();
    topController = parentController.addAndGet();
    bottomController = parentController.addAndGet();
  }

  void setCurrentIndex(int index) {
    _sideNavigationService.setCurrentIndex(index);
    rebuildUi();
  }

  Future<void> fetchChapter(int pageKey, AreaType areaType) async {
    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, areaType);

    final bool isLastPage = newPage.isEmpty;
    final int nextPageKey = pageKey + 1;

    if (areaType == AreaType.top) {
      if (isLastPage) {
        topPagingController.appendLastPage(newPage);
      } else {
        topPagingController.appendPage(newPage, nextPageKey);
      }
      topPagingController.notifyListeners();
    } else if (areaType == AreaType.bottom) {
      if (isLastPage) {
        bottomPagingController.appendLastPage(newPage);
      } else {
        bottomPagingController.appendPage(newPage, nextPageKey);
      }
      bottomPagingController.notifyListeners();
    }

    rebuildUi();
    log('Fetched chapter $areaType');
  }

  void setChapter(dynamic chapter) {
    if (chapter.runtimeType == String) {
      _biblesService.setChapter(int.parse(chapter));
    } else {
      _biblesService.setChapter(chapter);
    }
    rebuildUi();
  }

  List<Map<String, dynamic>> getPaginatedVerses(
      int pageKey, AreaType areaType) {
    log(areaType.toString());
    return _readerService.getPaginatedVerses(pageKey, context, areaType);
  }

  String getcurrentBookName() {
    return _biblesService.bookCodeToBook(bookCode);
  }

  String getcurrentNavigationString(String bookCode, int chapter) {
    final navStr = '${_biblesService.bookCodeToBook(bookCode)} $chapter';
    return navStr;
  }

  void toggleBottomSheet() {
    showBottomSheet = !showBottomSheet;
    rebuildUi();
  }

  void updateInterface() {
    topPagingController.notifyListeners();
    bottomPagingController.notifyListeners();
    rebuildUi();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_biblesService];
}
