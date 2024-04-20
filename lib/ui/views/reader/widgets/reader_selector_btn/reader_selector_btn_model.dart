import 'package:stacked/stacked.dart';

import '../../../../../app/app.locator.dart';
import '../../../../../services/bibles_service.dart';

class ReaderSelectorBtnModel extends BaseViewModel {
  final _biblesService = locator<BiblesService>();

  String get primaryAreaBible => _biblesService.primaryAreaBible;
  String get bookCode => _biblesService.bookCode;

}
