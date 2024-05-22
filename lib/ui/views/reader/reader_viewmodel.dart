import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/enums.dart';
import '../../../common/oet_rv_section_start_end.dart';
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
  int get sectionNumber => _biblesService.sectionNumber;

  ViewBy get viewBy => _biblesService.viewBy;

  double get textScaling => _settingsService.textScaling;
  bool get showSecondaryArea => _settingsService.showSecondaryArea;
  bool get linkReaderAreaScrolling => _settingsService.linkReaderAreaScrolling;

  ReaderViewModel({required this.context});

  final BuildContext context;

  late ScrollController primaryAreaController;
  late ScrollController secondaryAreaController;
  late LinkedScrollControllerGroup areasParentController;

  final Key downListKey = UniqueKey();

  PagingController<int, Map<String, dynamic>> primaryPagingUpController = PagingController(
    firstPageKey: 1,
  );
  PagingController<int, Map<String, dynamic>> primaryPagingDownController = PagingController(
    firstPageKey: 1,
  );

  PagingController<int, Map<String, dynamic>> secondaryPagingUpController = PagingController(
    firstPageKey: 1,
  );
  PagingController<int, Map<String, dynamic>> secondaryPagingDownController = PagingController(
    firstPageKey: 1,
  );

  bool isPrimaryReaderAreaPopupActive = false;
  bool isSecondaryReaderAreaPopupActive = false;

  int numberOfSections = 0;
  bool initialRefresh = false;
  int currentPage = 0;

  void initilize() async {
    if (linkReaderAreaScrolling == true) {
      areasParentController = LinkedScrollControllerGroup();
      primaryAreaController = areasParentController.addAndGet();
      secondaryAreaController = areasParentController.addAndGet();
    } else {
      areasParentController = LinkedScrollControllerGroup();
      primaryAreaController = ScrollController();
      secondaryAreaController = ScrollController();
    }
    await refreshReader();
  }

  @override
  void dispose() {
    primaryAreaController.dispose();
    secondaryAreaController.dispose();

    primaryPagingUpController.removePageRequestListener((pageKey) {});
    primaryPagingDownController.removePageRequestListener((pageKey) {});
    secondaryPagingUpController.removePageRequestListener((pageKey) {});
    secondaryPagingUpController.removePageRequestListener((pageKey) {});

    primaryPagingUpController.dispose();
    primaryPagingDownController.dispose();
    secondaryPagingUpController.dispose();
    secondaryPagingDownController.dispose();

    super.dispose();
  }

  Future<void> refreshReader() async {
    await _biblesService.reloadBiblesJson();

    if (viewBy == ViewBy.section) {
      currentPage = sectionNumber;
    } else {
      currentPage = chapterNumber;
    }

    // Primary area
    primaryPagingUpController = PagingController(
      firstPageKey: currentPage,
    );
    primaryPagingUpController.addPageRequestListener((pageKey) {
      fetchUp(pageKey, viewBy, Area.primary);
    });
    primaryPagingDownController = PagingController(
      firstPageKey: currentPage,
    );
    primaryPagingDownController.addPageRequestListener((pageKey) {
      fetchDown(pageKey, viewBy, Area.primary);
    });

    // Secondary area
    secondaryPagingUpController = PagingController(
      firstPageKey: currentPage,
    );
    secondaryPagingUpController.addPageRequestListener((pageKey) {
      fetchUp(pageKey, viewBy, Area.secondary);
    });
    secondaryPagingDownController = PagingController(
      firstPageKey: currentPage,
    );
    secondaryPagingDownController.addPageRequestListener((pageKey) {
      fetchDown(pageKey, viewBy, Area.secondary);
    });

    initialRefresh = true;
    numberOfSections = sectionStartEndMappingForOET[bookCode]!.length;

    // Refresh for first section/chapter
    fetchDown(currentPage, viewBy, Area.primary);
    fetchUp(currentPage, viewBy, Area.primary);

    fetchDown(currentPage, viewBy, Area.secondary);
    fetchUp(currentPage, viewBy, Area.secondary);

    rebuildUi();
  }

  void fetchUp(int pageKey, ViewBy viewBy, Area area) {
    if (viewBy == ViewBy.section) {
      fetchUpSection(pageKey, area);
    } else if (viewBy == ViewBy.chapter) {
      fetchUpChapter(pageKey, area);
    }
    log('UP | $viewBy | $area | $pageKey');
  }

  void fetchDown(int pageKey, ViewBy viewBy, Area area) {
    if (viewBy == ViewBy.section) {
      fetchDownSection(pageKey, area);
    } else if (viewBy == ViewBy.chapter) {
      fetchDownChapter(pageKey, area);
    }
    log('DOWN | $viewBy | $area | $pageKey');
  }

  void fetchUpSection(int pageKey, Area area) {
    if (currentPage != 0) {
      if (initialRefresh == true) {
        pageKey -= 1;
        initialRefresh = false;
      }

      int key = (pageKey.abs());

      List<Map<String, dynamic>> newPage = getPaginatedVerses(key, area);

      final int nextPageKey = pageKey - 1;

      final bool isLastPage;
      if (currentPage != 0) {
        isLastPage = key == 0;
      } else {
        isLastPage = true;
      }

      if (area == Area.primary) {
        if (isLastPage) {
          primaryPagingUpController.appendLastPage(newPage);
        } else {
          primaryPagingUpController.appendPage(newPage, nextPageKey);
        }
      } else if (area == Area.secondary) {
        if (isLastPage) {
          secondaryPagingUpController.appendLastPage(newPage);
        } else {
          secondaryPagingUpController.appendPage(newPage, nextPageKey);
        }
      }
    } else {
      // If the currentPage is the first one, we know there isn't any previous pages
      primaryPagingUpController.appendLastPage([]);
      secondaryPagingUpController.appendLastPage([]);
    }
    updatePagingControllers();
  }

  // Future<void> fetchUpChapter(int pageKey, Area area) async {
  //   if (currentPage != 1) {
  //     pageKey -= 1;

  //     List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

  //     final bool isLastPage = pageKey == 0;
  //     final int nextPageKey = pageKey;

  //     if (area == Area.primary) {
  //       if (isLastPage) {
  //         primaryPagingUpController.appendLastPage(newPage);
  //       } else {
  //         primaryPagingUpController.appendPage(newPage, nextPageKey);
  //       }
  //     } else if (area == Area.secondary) {
  //       if (isLastPage) {
  //         secondaryPagingUpController.appendLastPage(newPage);
  //       } else {
  //         secondaryPagingUpController.appendPage(newPage, nextPageKey);
  //       }
  //     }
  //   } else {
  //     // If the currentPage is the first one, we know there isn't any previous pages
  //     primaryPagingUpController.appendLastPage([]);
  //     secondaryPagingUpController.appendLastPage([]);
  //   }

  //   updatePagingControllers();
  // }

  void fetchUpChapter(int pageKey, Area area) {
    pageKey -= 1;

    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final bool isLastPage = pageKey == 1;
    final int nextPageKey = pageKey;

    if (area == Area.primary) {
      if (isLastPage) {
        primaryPagingUpController.appendLastPage(newPage);
      } else {
        primaryPagingUpController.appendPage(newPage, nextPageKey);
      }
    } else if (area == Area.secondary) {
      if (isLastPage) {
        secondaryPagingUpController.appendLastPage(newPage);
      } else {
        secondaryPagingUpController.appendPage(newPage, nextPageKey);
      }
    }
    updatePagingControllers();
  }

  void fetchDownSection(int pageKey, Area area) {
    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final int nextPageKey = pageKey + 1;
    final bool isLastPage;
    if (currentPage != (numberOfSections - 1)) {
      isLastPage = pageKey == (numberOfSections - 1);
    } else {
      isLastPage = true;
    }

    if (area == Area.primary) {
      if (isLastPage) {
        primaryPagingDownController.appendLastPage(newPage);
      } else {
        primaryPagingDownController.appendPage(newPage, nextPageKey);
      }
    } else if (area == Area.secondary) {
      if (isLastPage) {
        secondaryPagingDownController.appendLastPage(newPage);
      } else {
        secondaryPagingDownController.appendPage(newPage, nextPageKey);
      }
    }
    updatePagingControllers();
  }

  void fetchDownChapter(int pageKey, Area area) {
    List<Map<String, dynamic>> newPage = getPaginatedVerses(pageKey, area);

    final bool isLastPage = newPage.isEmpty;
    final int nextPageKey = pageKey + 1;

    if (area == Area.primary) {
      if (isLastPage) {
        primaryPagingDownController.appendLastPage(newPage);
      } else {
        primaryPagingDownController.appendPage(newPage, nextPageKey);
      }
    } else if (area == Area.secondary) {
      if (isLastPage) {
        secondaryPagingDownController.appendLastPage(newPage);
      } else {
        secondaryPagingDownController.appendPage(newPage, nextPageKey);
      }
    }
    updatePagingControllers();
  }

  void setChapter(dynamic chapter) {
    if (chapter is String) {
      _biblesService.setChapter(int.parse(chapter));
    } else if (chapter is int) {
      _biblesService.setChapter(chapter);
    }
    rebuildUi();
  }

  List<Map<String, dynamic>> getPaginatedVerses(int pageKey, Area area) {
    return _readerService.getNewPage(context, pageKey, area);
  }

  void onTapCloseSecondaryArea() {
    _settingsService.setShowSecondaryArea(false);
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

  void toggleSecondaryArea() {
    _settingsService.setShowSecondaryArea(!showSecondaryArea);
    rebuildUi();
  }

  void updatePagingControllers() {
    primaryPagingUpController.notifyListeners();
    primaryPagingDownController.notifyListeners();

    secondaryPagingUpController.notifyListeners();
    secondaryPagingDownController.notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_settingsService, _biblesService];
}
