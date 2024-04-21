import 'package:stacked/stacked.dart';

import '../../../../../app/app.locator.dart';
import '../../../../../services/bibles_service.dart';

class ReaderSelectorBtnModel extends BaseViewModel {
  final _biblesService = locator<BiblesService>();

  String get primaryBible => _biblesService.primaryBible;
  String get secondaryBible => _biblesService.secondaryBible;
  String get bookCode => _biblesService.bookCode;
}
