import 'package:flutter/material.dart';

import '../json_to_bible.dart';
import '../text_item.dart';

/// KJV version implementation
class KJVBibleImpl extends JsonToBible {
  KJVBibleImpl(BuildContext context, Map<String, dynamic> json) : super(context: context, json: json);

  /// Get the KJV chapter spans for [page].
  @override
  List<Map<String, dynamic>> getChapter(int page) {
    List<InlineSpan> spans = [];

    // Chapters
    List<dynamic> chaptersData = json['chapters'];

    String chapterNumber = '';
    List<dynamic> chapterContents = [];

    for (Map<dynamic, dynamic> chapter in chaptersData) {
      chapterNumber = chapter['chapter'];

      if (chapterNumber == page.toString()) {
        spans.add(TextSpan(
          text: chapterNumber == '1' ? '$chapterNumber ' : '\n$chapterNumber ',
          style: TextItemStyles.chapterHeading(context),
        ));
        chapterContents = chapter['verses'];
        break;
      }
    }

    for (Map item in chapterContents) {
      spans.add(
        TextSpan(
          children: [
            TextSpan(
              text: ' ${item['verse']} ',
              style: TextItemStyles.bodyMedium(context),
            ),
            TextSpan(
              text: item['text'],
              style: TextItemStyles.text(context),
            ),
          ],
        ),
      );
    }

    return [
      {
        'spans': spans,
        'page': chapterNumber,
      }
    ];
  }
}
