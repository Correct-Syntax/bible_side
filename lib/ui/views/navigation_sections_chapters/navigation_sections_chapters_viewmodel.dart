import 'dart:developer';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../common/books.dart';
import '../../../common/enums.dart';
import '../../../common/oet_rv_section_headings.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class NavigationSectionsChaptersViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();
  final _navigationService = locator<NavigationService>();

  String get primaryBible => _settingsService.primaryBible;
  String get secondaryBible => _settingsService.secondaryBible;
  List<String> get recentBooks => _settingsService.recentBooks;

  bool displaySections = true;
  List<String> bookChapters = [];
  List<List<String>> sections = [];

  NavigationSectionsChaptersViewModel({required this.readerArea, required this.bookCode});

  final Area readerArea;
  final String bookCode;

  Future<void> initilize() async {
    // Generate list of chapters
    int numOfChapters =
        bookNumOfChaptersMapping.values.firstWhere((element) => element == bookNumOfChaptersMapping[bookCode]);
    bookChapters = [for (int i = 1; i <= numOfChapters; i++) i.toString()];

    // Generate sections
    sections = sectionHeadingsMappingForOET[bookCode]!;

    // Set whether to show by sections or by chapters
    displaySections = _biblesService.isReaderBibleOET(readerArea);

    rebuildUi();
  }

  String getFirstSectionHeading(int index) {
    return sections[index][0];
  }

  Iterable<String> getAlternativeSectionHeadings(int index) {
    return sections[index].skip(1); // Skip the first section heading
  }

  Future<void> onTapSectionItem(int index) async {
    _biblesService.setBook(bookCode);
    _biblesService.addBookToRecentHistory(bookCode);

    //_biblesService.setViewBy(ViewBy.section);
    String sectionHeading = sections[index][0];
    log(sectionHeading);
    _biblesService.setSection(index);

    _navigationService.clearStackAndShow(Routes.readerView);
    await _biblesService.reloadBiblesJson();
  }

  // For bibles that do not have a by section implementation
  Future<void> onTapChapterItem(int index) async {
    _biblesService.setBook(bookCode);
    _biblesService.addBookToRecentHistory(bookCode);
    //_biblesService.setViewBy(ViewBy.chapter);
    _biblesService.setChapter(index);

    _navigationService.clearStackAndShow(Routes.readerView);
    await _biblesService.reloadBiblesJson();
  }
}
