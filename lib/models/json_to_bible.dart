import 'package:flutter/material.dart';

import 'text_item.dart';

abstract class JsonToBible {
  final BuildContext context;
  final Map<String, dynamic> json;

  JsonToBible({
    required this.context,
    required this.json,
  });

  bool isNumeric(String str) {
    return int.tryParse(str) != null;
  }

  Iterable<String> allStringMatches(String text, RegExp regExp) {
    Iterable<Match> matches = regExp.allMatches(text);
    List<Match> listOfMatches = matches.toList();

    Iterable<String> listOfStringMatches = listOfMatches.map((Match m) {
      return m.input.substring(m.start, m.end).trim();
    });

    return listOfStringMatches;
  }

  List<Map<String, dynamic>> getSection(int page, Map<String, dynamic> sectionReferences) {
    List<InlineSpan> spans = [];

    return [
      {
        'spans': spans,
        'page': page.toString(),
      }
    ];
  }

  List<Map<String, dynamic>> getChapter(int page) {
    List<InlineSpan> spans = [];

    return [
      {
        'spans': spans,
        'page': page.toString(),
      }
    ];
  }

  /// For debugging sections
  List<Map<String, dynamic>> getSectionDebug(Map<String, dynamic> sectionReferences) {
    return [
      {
        'spans': [
          TextSpan(
            text: '\n\n\n\n $sectionReferences \n\n\n\n',
            style: TextItemStyles.text(context),
          ),
        ],
        'page': '-',
      }
    ];
  }
}
