/*
BibleSide Copyright 2023 Noah Rahm

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';


class TextItem {
  final String text;
  final String type;
  final TextStyle style;
  final void Function(BuildContext)? callback;

  TextItem({
    required this.text,
    required this.type,
    required this.style,
    this.callback,
  });
}


class ReaderTextWidgets {

  static TextItem bookHeading(String book, BuildContext context) {
    return TextItem(
      text: '$book',
      type: "bookHeading",
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500)
    );
  }

  static TextItem chapterHeading(String chapter, BuildContext context) {
    return TextItem(
      text: chapter == '1' ? 'Chapter $chapter' : '\nChapter $chapter',
      type: "chapterHeading",
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500)
    );
  }

  static TextItem sectionHeading(String heading, BuildContext context) {
    return TextItem(
      text: '\n$heading ',
      type: "sectionHeading",
      style: Theme.of(context).textTheme.bodyMedium!
    );
  }

  static TextItem verseNumber(String verseNumber, BuildContext context) {
    return TextItem(
      text: '\n$verseNumber ',
      type: "verseNumber",
      style: Theme.of(context).textTheme.bodyMedium!
    );
  }

  static TextItem verseText(String verseText, BuildContext context) {
    return TextItem(
      text: verseText,
      type: "verseText",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20)
    );
  }

  static TextItem verseLinkText(String verseLink, BuildContext context) {
    return TextItem(
      text: verseLink,
      type: "verseLink",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue),
      callback: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You tapped the link"),
          ),
        );
      },
    );
  }
}