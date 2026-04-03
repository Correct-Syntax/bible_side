import 'package:stacked/stacked.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../../common/oet_rv_section_headings.dart';

class TopReaderAppbarModel extends BaseViewModel {

  Map<String, dynamic> data = sectionHeadingsMappingForOET;

  // Future<void> loadJson(String bibleCode, String bookCode) async {
  //   final String jsonString = await rootBundle.loadString('$basePath');
  //   data = json.decode(jsonString);
  // }
  String getSectionPrimaryORSecondary(String primaryVersion, String? secondaryVersion, String book, int chapter, int verse) {
    if(primaryVersion == 'OET-RV') {
      return getSectionIfRV(primaryVersion, book, chapter, verse);
    }
    return getSectionIfRV(secondaryVersion ?? '', book, chapter, verse);
  }

  String getSectionIfRV(String version, String book, int chapter, int verse) {
    if(version == 'OET-RV') {
      return getSection(book, chapter, verse);
    }
    return '$chapter:$verse';
  }

  String getSection(String book, int chapter, int verse) {
    final List<List<String>> sections = data[book];
    String lastSectionHeading = '';

    // if section starts with chapter and verse
    for (var section in sections) {
      int ch = int.parse(section[0].split(' ')[0].split(':')[0]); // ex: '1' in '1:19 Jesus did this'
      int ve = int.parse(section[0].split(' ')[0].split(':')[1]); // ex: '19' in '1:19 Jesus did this'
      if(ch < chapter || (ch == chapter && ve < verse)) {
        lastSectionHeading = section[0].split(' ').sublist(1).join(' '); // ex: 'Jesus did this' in '1:19 Jesus did this'
        continue; // keep looking for the section that matches the current chapter and verse
      }
      if(ch == chapter && ve == verse) {
        return section[0].split(' ').sublist(1).join(' '); // ex: 'Jesus did this' in '1:19 Jesus did this'
      }
      else if(ch > chapter || (ch == chapter && ve > verse)) {
        return lastSectionHeading; // return the last section heading that was before the current chapter and verse; if there was none, this will return an empty string
      }
    }

    // if verse does not start new section
    return '';
  }
}
