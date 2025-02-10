import 'package:stacked/stacked.dart';

import '../../../../../common/books.dart';

class SearchResultItemModel extends BaseViewModel {
  String getReference(String bookCode, int chapter, int verse) {
    return '${BooksMapping.bookNameFromBookCode(bookCode)} $chapter:$verse';
  }
}
