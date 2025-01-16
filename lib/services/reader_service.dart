import '../app/app.locator.dart';
import '../common/enums.dart';
import '../models/bibles/kjv_bible.dart';
import '../models/bibles/oet_lv_bible.dart';
import '../models/bibles/oet_rv_bible.dart';
import 'bibles_service.dart';

class ReaderService {
  final _biblesService = locator<BiblesService>();

  Map<String, dynamic> get primaryAreaJson => _biblesService.primaryAreaJson;
  Map<String, dynamic> get secondaryAreaJson => _biblesService.secondaryAreaJson;

  /// An "Area" is the area in the reader where bible text is displayed and scrolled.
  Future<String> getReaderBookHTML(Area area, ViewBy viewBy, String bibleCode, String bookCode, List<String> bookmarks,
      bool showMarks, bool showChaptersAndVerses) async {
    Map<String, dynamic> json;
    if (area == Area.primary) {
      json = primaryAreaJson;
    } else {
      json = secondaryAreaJson;
    }

    if (bibleCode == 'OET-LV') {
      var bibleImpl = OETLiteralBibleImpl(json);
      return await bibleImpl.getBook(area, bookCode, bookmarks, showMarks, showChaptersAndVerses);
    } else if (bibleCode == 'OET-RV') {
      var bibleImpl = OETReadersBibleImpl(json);
      return await bibleImpl.getBook(area, bookCode, bookmarks, showMarks, showChaptersAndVerses);
    } else if (bibleCode == 'KJV') {
      var bibleImpl = KJVBibleImpl(json);
      return await bibleImpl.getBook(area, bookCode, bookmarks, showMarks, showChaptersAndVerses);
    } else {
      return 'Invalid bibleCode.';
    }
  }
}
