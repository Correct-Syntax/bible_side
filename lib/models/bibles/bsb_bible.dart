import 'package:flutter/foundation.dart';

import '../../common/enums.dart';
import '../json_to_bible.dart';
import '../search_result.dart';

/// The Berean Standard Bible (BSB) implementation.
/// This code is based on the web_bible.dart implementation, since the WEB json structure seemed most similar to the WEB json.
/// The BSB is displayed in chapters verse-by-verse.

class BSBBibleImpl extends JsonToBible {
  BSBBibleImpl(Map<String, dynamic> json) : super(json: json);

  @override
  Future<String> getBook(
    Area readerArea,
    String bookCode,
    List<String> bookmarks,
    bool showSpecialMarks,
    bool showChaptersAndVerses,
  ) async {
    String htmlText = '';
    String tempHTML = '';
    String chapterNumberHtml = '';
    String chapterNumber = '1';
    String verseNumber = '1';
    
    for (Map item in json['content']) {
      // Chapter 'chapter'
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];

        String chapterId = '${readerArea.name}-$bookCode-$chapterNumber';

        chapterNumberHtml = '''<span class="c" id="$chapterId">
          ${showChaptersAndVerses ? chapterNumber : ''}
        </span>''';
      }

      // Paragraph 'para': only want 'para' type items that have inner 'content'. 
      // The BSB json has some 'para' type items that are just empty paragraphs with no inner 'content'; we want to ignore those.
      else if (item['type'] == 'para' && item['content'] != null) {
        if(tempHTML != '') {
          // The BSB json contains split-up sentences where a verse is split across multiple 'para' items, so we want to concatenate the text from those 
          // 'para' items together before adding it to htmlText. The solution is to accumulate verse text,
          // then emit (add to htmlText, which is returned at the end of the function) that accumulated text when we reach the next paragraph or chapter, 
          // or the end of the book.
          
          // Starting a new paragraph, so emit any verse text stored in tempHTML from the previous paragraph before processing the new paragraph.
          htmlText += tempHTML;
          tempHTML = '';
        }
        
        for (dynamic paraItem in item['content']) {
          if (paraItem is String) {
            // The BSB json has some q1 and q2 markers, in addition to p markers, so we want to include those as well.
            if (item['marker'] == 'p' || item['marker'] == 'q1' || item['marker'] == 'q2') {
              tempHTML += '$paraItem ';
            }
          } else if (paraItem is Map) {
            String itemType = paraItem['type'];

            if (itemType == 'verse') {
              // Before starting a new verse, if there is any verse text stored in tempHTML from the previous verse, we want to add that to htmlText.
              if(tempHTML != '') {
                htmlText += '$tempHTML</p>';
                tempHTML = '';
              }
              verseNumber = paraItem['number'];

              String verseId = '${readerArea.name}-$bookCode-$chapterNumber-$verseNumber';
              String bookmarkIcon = bookmarkIconHTML(verseId, bookmarks);

              if (verseNumber == '1') {
                tempHTML += """<p ondblclick="onCreateBookmark("$verseId")" class="p" id="$verseId">
                  $chapterNumberHtml$bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;""";
              } else {
                tempHTML += """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">
$bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;""";
              }
            } else if (itemType == 'char') {
              for (dynamic charItem in paraItem['content']) {
                if (charItem is String) {
                  tempHTML += charItem;
                } else if (charItem is Map) {
                  // The BSB json has some 'char' type items that have inner 'content' which is a list of strings, and we want to concatenate those strings together.
                  if (charItem['type'] == 'verse') {
                    if(tempHTML != '') {
                      htmlText += '$tempHTML</p>';
                      tempHTML = '';
                    }
                    verseNumber = charItem['number'];

                    String verseId = '${readerArea.name}-$bookCode-$chapterNumber-$verseNumber';
                    String bookmarkIcon = bookmarkIconHTML(verseId, bookmarks);

                    if (verseNumber == '1') {
                      tempHTML += """<p ondblclick="onCreateBookmark("$verseId")" class="p" id="$verseId">
                      $chapterNumberHtml$bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;""";
                    } else {
                      tempHTML += """<p ondblclick=onCreateBookmark("$verseId") class="p" id="$verseId">
          $bookmarkIcon<sup>${showChaptersAndVerses ? verseNumber : ''}</sup>&nbsp;""";
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // After processing all paragraphs, if there is any verse text left over in tempHTML 
    // from the last verse, add that to htmlText.
    if(tempHTML != '') {
      htmlText += tempHTML;
    }
    
    return htmlText;
  }

  // Not all json-processing changes from BSBBibleImpl getBook made it into the getSearchResults implementation, 
  // and it's not obvious whether those changes are necessary for getSearchResults to work correctly.
  // Someone who better understands getSearchResults and has more time may need to integrate the relevant 
  // changes, especially those related to embedded json Maps within json Maps.
  // 2026-04-03 - S. Brandle

  @override
  Future<List<SearchResult>> getSearchResults(String bookCode, String searchTerm) async {
    List<SearchResult> results = [];

    String chapterNumber = '';
    String verseNumber = '';
    String verseText = '';

    for (Map item in json['content']) {
      // Chapter 'chapter'
      if (item['type'] == 'chapter') {
        chapterNumber = item['number'];
      }

      // The BSB has some 'para' type items that are just empty paragraphs with no inner 'content', 
      // so we need to check for null before iterating over 'content'.
       
      if (item['type'] == 'para' && item['content'] != null) {
        for (dynamic paraItem in item['content']) {
          if (paraItem is String) {
            if (item['marker'] == 'p' || item['marker'] == 'q1' || item['marker'] == 'q2' ) {
              verseText = paraItem;
            }
          } else if (paraItem is Map) {
            String itemType = paraItem['type'];

            if (itemType == 'verse') {
              verseNumber = paraItem['number'];

              bool isSearchTermInVerse = verseText.toLowerCase().contains(searchTerm);
              if (isSearchTermInVerse == true) {
                results.add(SearchResult(
                  bookCode: bookCode,
                  chapter: int.parse(chapterNumber),
                  verse: int.parse(verseNumber),
                  verseText: verseText,
                ));
              }
            }
          }
        }
      }
    }

    return results;
  }
}
