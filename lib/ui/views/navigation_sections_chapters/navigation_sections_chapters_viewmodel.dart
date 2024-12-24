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

  NavigationSectionsChaptersViewModel({
    required this.readerArea,
    required this.bookCode,
  });

  final Area readerArea;
  final String bookCode;

  Future<void> initilize() async {
    // Generate list of chapters.
    int numOfChapters =
        bookNumOfChaptersMapping.values.firstWhere((element) => element == bookNumOfChaptersMapping[bookCode]);
    bookChapters = [for (int i = 1; i <= numOfChapters; i++) i.toString()];

    // Set whether to show by sections or by chapters.
    displaySections = _biblesService.isReaderBibleOET(readerArea);

    // Generate sections.
    if (displaySections) {
      sections = sectionHeadingsMappingForOET[bookCode]!;
    }

    rebuildUi();
  }

  String getFirstSectionHeading(int index) {
    return sections[index][0];
  }

  Iterable<String> getAlternativeSectionHeadings(int index) {
    // Skip the first section heading
    return sections[index].skip(1);
  }

  Future<void> onTapSectionItem(int index) async {
    _biblesService.setViewBy(ViewBy.section);

    _biblesService.setBook(bookCode);
    _biblesService.addBookToRecentHistory(bookCode);

    String sectionHeading = sections[index][0];
    String? chapterVerseString = RegExp('([0-9]*:[0-9]*)').firstMatch(sectionHeading)?[0];

    assert(chapterVerseString != null);

    if (chapterVerseString != null) {
      var [chapter, verse] = chapterVerseString.split(':');
      _biblesService.setChapter(int.parse(chapter));
      _biblesService.setVerse(int.parse(verse));
    } else {
      // Fallback
      _biblesService.setVerse(1);
    }
    _navigationService.clearStackAndShow(Routes.readerView);
  }

  // For Bibles that do not have a by section implementation
  Future<void> onTapChapterItem(int index) async {
    _biblesService.setViewBy(ViewBy.chapter);

    _biblesService.setBook(bookCode);
    _biblesService.addBookToRecentHistory(bookCode);

    _biblesService.setChapter(index);
    _biblesService.setVerse(1);

    _navigationService.clearStackAndShow(Routes.readerView);
  }
}
