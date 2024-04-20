import 'dart:developer';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/bibles_service.dart';
import '../../../services/settings_service.dart';

class NavigationSectionsChaptersViewModel extends BaseViewModel {
  final _settingsService = locator<SettingsService>();
  final _biblesService = locator<BiblesService>();
  final _navigationService = locator<NavigationService>();

  String get bookCode => _settingsService.bookCode;
  List<String> get recentBooks => _settingsService.recentBooks;

  List<String> bookChapters = [];
  List<List<String>> sections = [];


  Future<void> initilize() async {
    // TODO: init sections here

  }

  String getFirstSectionHeading(int index) {
    return sections[index][0];
  }

  Iterable<String> getAlternativeSectionHeadings(int index) {
    return sections[index].skip(1); // Skip the first section heading
  }

  Future<void> onTapChapterItem(int index) async {
    
  }

  Future<void> onTapSectionItem(int index) async {

  }
}
