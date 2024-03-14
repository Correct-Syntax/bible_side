/// Shared code between the OET bible implementations
/// LV is displayed by verse
/// RV is displayed by paragraph
mixin OETBaseMixin {
  /// Given a [reference] like "1:3 Yeshua, alive, tells them to wait",
  /// returns "Yeshua, alive, tells them to wait".
  String sectionHeadingFromReference(String reference) {
    RegExp regex = RegExp(r'(\d*:\d*)');
    return reference.split(regex).last;
  }

  /// Get the section json between [sectionReferences]
  ///
  /// [sectionReferences] is a list of 2 strings formatted like ['1:11', '1:12']
  ///
  /// Returns a list of json contents
  List<dynamic> getJsonForSection(Map<String, dynamic> json, Map<String, dynamic> sectionReferences) {
    List<dynamic> sectionContents = [];

    // First get the chapter json where this section appears
    Map<String, int> startReference = sectionReferences['start']!;
    int startChapter = startReference['chapter']!;
    int startVerse = startReference['verse']!;
    Map<String, List<dynamic>> jsonForChapter = getJsonForChapter(json, startChapter);

    Map<String, int> endReference = sectionReferences['end']!;
    int endVerse = endReference['verse']!;

    if (jsonForChapter.isNotEmpty) {
      List<dynamic> chapterContentsJson = jsonForChapter.values.first;

      bool sectionStart = false;
      bool sectionEnd = false;

      for (Map<String, dynamic> item in chapterContentsJson) {
        // Find the start verse of the section
        if (item.containsKey('verseNumber') && sectionContents.isEmpty) {
          // If the starting verse is 1 then add the json for that verse
          if (startVerse == 1) {
            sectionContents.add(item);
            sectionStart = true;
            // We know that the section will start at this verse
          } else if (item['verseNumber'] == startVerse.toString()) {
            sectionContents.add(item);
            sectionStart = true;
          }
        } else {
          // Find the end verse of the section
          if (item.containsKey('verseNumber') && sectionStart == true) {
            if (item['verseNumber'] == endVerse.toString()) {
              sectionEnd = true;
            } else {
              sectionContents.add(item);
            }
          }
        }

        // We have the section contents, so exit loop
        if (sectionStart == true && sectionEnd == true) {
          break;
        }
      }
    }

    //log('${sectionContents.toString()});
    return sectionContents;
  }

  /// Get the chapter json at the chapter corresponding to [index].
  Map<String, List<dynamic>> getJsonForChapter(Map<String, dynamic> json, int index) {
    List<dynamic> chaptersData = json['chapters'];

    String chapterNumber = '';
    List<dynamic> chapterContents = [];
    for (Map<String, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapterNumber'];
      if (chapterNumber == index.toString()) {
        chapterContents = chapter['contents'];
        break;
      }
    }
    //log('$chapterNumber : ${chapterContents.toString()});
    return {
      chapterNumber: chapterContents,
    };
  }
}
