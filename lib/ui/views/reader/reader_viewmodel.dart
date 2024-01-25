import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../services/bibles_service.dart';
import '../../../services/reader_service.dart';
import '../../../services/side_navigation_service.dart';

class ReaderViewModel extends ReactiveViewModel {
  final _sideNavigationService = locator<SideNavigationService>();
  final _biblesService = locator<BiblesService>();
  final _readerService = locator<ReaderService>();
  final _navigationService = locator<NavigationService>();

  int get currentIndex => _sideNavigationService.currentIndex;

  String get primaryAreaBible => _biblesService.primaryAreaBible;
  String get bookCode => _biblesService.bookCode;
  int get chapter => _biblesService.chapterNumber;

  int get sectionIndex => _biblesService.chapterNumber; // TODO

  ReaderViewModel({required this.context});

  final BuildContext context;

  late ScrollController topController;
  late ScrollController bottomController;
  late LinkedScrollControllerGroup parentController;

  final Key downListKey = UniqueKey();

  bool showSecondaryArea = true;

  PagingController<int, Map<String, dynamic>> topPagingUpController = PagingController(
    firstPageKey: 1,
  );
  PagingController<int, Map<String, dynamic>> topPagingDownController = PagingController(
    firstPageKey: 1,
  );

  PagingController<int, Map<String, dynamic>> bottomPagingUpController = PagingController(
    firstPageKey: 1,
  );
  PagingController<int, Map<String, dynamic>> bottomPagingDownController = PagingController(
    firstPageKey: 1,
  );

  Future<void> initilize() async {
    parentController = LinkedScrollControllerGroup();
    topController = parentController.addAndGet();
    bottomController = parentController.addAndGet();

    await initReader();
  }

  Future<void> initReader() async {
    await _biblesService.reloadBiblesJson();

    // Top
    topPagingUpController = PagingController(
      firstPageKey: sectionIndex,
    );
    topPagingDownController = PagingController(
      firstPageKey: sectionIndex,
    );

    topPagingUpController.addPageRequestListener((pageKey) {
      fetchUpChapter(pageKey, Area.primary);
      updateInterface();
    });
    topPagingDownController.addPageRequestListener((pageKey) {
      fetchDownChapter(pageKey, Area.primary);
      updateInterface();
    });

    // Bottom
    bottomPagingUpController = PagingController(
      firstPageKey: sectionIndex,
    );
    bottomPagingDownController = PagingController(
      firstPageKey: sectionIndex,
    );

    bottomPagingUpController.addPageRequestListener((pageKey) {
      fetchUpChapter(pageKey, Area.secondary);
      //updateInterface();
    });
    bottomPagingDownController.addPageRequestListener((pageKey) {
      fetchDownChapter(pageKey, Area.secondary);
      //updateInterface();
    });

    await fetchDownChapter(sectionIndex, Area.primary);
    await fetchDownChapter(sectionIndex, Area.secondary);

    log(sectionIndex.toString());

    rebuildUi();
  }

  void setCurrentIndex(int index) {
    _sideNavigationService.setCurrentIndex(index);
    rebuildUi();
  }

  Future<void> fetchUpChapter(int pageKey, Area area) async {
    pageKey -= 1;

    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final bool isLastPage = pageKey == 1;
    final int nextPageKey = pageKey;

    if (area == Area.primary) {
      if (isLastPage) {
        topPagingUpController.appendLastPage(newPage);
      } else {
        topPagingUpController.appendPage(newPage, nextPageKey);
      }
      topPagingUpController.notifyListeners();
    } else if (area == Area.secondary) {
      if (isLastPage) {
        bottomPagingUpController.appendLastPage(newPage);
      } else {
        bottomPagingUpController.appendPage(newPage, nextPageKey);
      }
      bottomPagingUpController.notifyListeners();
    }

    log('Fetched up chapter for $area');
  }

  Future<void> fetchDownChapter(int pageKey, Area area) async {
    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final bool isLastPage = newPage.isEmpty;
    final int nextPageKey = pageKey + 1;

    if (area == Area.primary) {
      if (isLastPage) {
        topPagingDownController.appendLastPage(newPage);
      } else {
        topPagingDownController.appendPage(newPage, nextPageKey);
      }
      topPagingDownController.notifyListeners();
    } else if (area == Area.secondary) {
      if (isLastPage) {
        bottomPagingDownController.appendLastPage(newPage);
      } else {
        bottomPagingDownController.appendPage(newPage, nextPageKey);
      }
      bottomPagingDownController.notifyListeners();
    }

    log('Fetched down chapter for $area');
  }

  void setChapter(dynamic chapter) {
    if (chapter.runtimeType == String) {
      _biblesService.setChapter(int.parse(chapter));
    } else if (chapter.runtimeType == int) {
      _biblesService.setChapter(chapter);
    }
    rebuildUi();
  }

  List<Map<String, dynamic>> getPaginatedVerses(int pageKey, Area area) {
    return _readerService.getNewPage(context, pageKey, area);
  }

  String getcurrentBookName() {
    return _biblesService.bookCodeToBook(bookCode);
  }

  String getcurrentNavigationString(String bookCode, int chapter) {
    final navStr = '${_biblesService.bookCodeToBook(bookCode)} $chapter';
    return navStr;
  }

  void onNavigationBtn() {
    _navigationService.navigateToReaderNavigationView();
  }

  void onBiblesBtn() {
    _navigationService.navigateToBiblesView();
  }

  void toggleSecondaryArea() {
    showSecondaryArea = !showSecondaryArea;
    rebuildUi();
  }

  void updateInterface() {
    topPagingUpController.notifyListeners();
    bottomPagingUpController.notifyListeners();

    topPagingDownController.notifyListeners();
    bottomPagingDownController.notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_biblesService];
}
