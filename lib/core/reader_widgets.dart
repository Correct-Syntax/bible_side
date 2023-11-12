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

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


/// Valid types determining how to divide the reader text.
enum ReaderType {
  verse,
  paragraph
}


/// The Base [TextItem] structure
/// 
/// TextItem represents the content and visual style of a certain type of text. See [TextItemType].
class TextItem {
  final String text;
  final TextItemType type;
  final TextStyle style;
  final void Function(BuildContext)? callback;

  TextItem({
    required this.text,
    required this.type,
    required this.style,
    this.callback,
  });
}


/// Valid types describing a [TextItem]
enum TextItemType {
  bookHeading,
  chapterHeading,
  sectionHeading,
  verseNumber,
  verseText,
  verseLink,
}


/// [TextItem] styles
class TextItemStyles {

  static TextStyle bookHeading(context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle chapterHeading(context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500);
  }

  static TextStyle bodyMedium(context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  static TextStyle text(context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20);
  }

  static TextStyle link(context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue);
  }
}


/// TextItems
class ReaderTextItems {
  ReaderTextItems(this.readerType);

  final ReaderType readerType; // TODO: specify a reader type for styling specific to that reader


  static TextItem bookHeading(String book, BuildContext context) {
    return TextItem(
      text: book,
      type: TextItemType.bookHeading,
      style: TextItemStyles.bookHeading(context)
    );
  }

  static TextItem chapterHeading(String chapter, BuildContext context) {
    return TextItem(
      text: chapter == '1' ? 'Chapter $chapter' : '\nChapter $chapter', // Add newline before all but the first chapter
      type: TextItemType.chapterHeading,
      style: TextItemStyles.chapterHeading(context)
    );
  }

  static TextItem sectionHeading(String heading, BuildContext context) {
    return TextItem(
      text: '\n$heading ',
      type: TextItemType.sectionHeading,
      style: TextItemStyles.bodyMedium(context)
    );
  }

  static TextItem verseNumber(String verseNumber, BuildContext context) {
    return TextItem(
      text: '\n$verseNumber ',
      type: TextItemType.verseNumber,
      style: TextItemStyles.bodyMedium(context)
    );
  }

  static TextItem verseText(String verseText, BuildContext context) {
    return TextItem(
      text: verseText,
      type: TextItemType.verseText,
      style: TextItemStyles.text(context)
    );
  }

  static TextItem verseLinkText(String verseLink, Function onTap, BuildContext context) {
    return TextItem(
      text: verseLink,
      type: TextItemType.verseLink,
      style: TextItemStyles.link(context),
      callback: (context) {
        onTap(context);
        // TODO: remove
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You tapped the link"),
          ),
        );
      },
    );
  }
}



class ReaderContentBuilder {

  List<TextItem> buildTextItemsFromJson(Map<String, dynamic> json, BuildContext context) {
    List<TextItem> textItems = [];

    // Book data
    Map<String, dynamic> bookData = json['book'];
    //log(bookData.toString());
    List<dynamic> bookDataMeta = bookData['meta'];

    // for (Map<String, dynamic> meta in bookDataMeta) {
    //   //log(meta.toString());
    //   for (String key in meta.keys) {
    //     if (key == 'h') {
    //       textItems.add(ReaderTextWidgets.bookHeading(meta[key], context));
    //     }
    //   }
    // }

    // Chapters
    List<dynamic> chaptersData = json['chapters'];
    
    // Loop through chapter data
    for (Map<String, dynamic>chapter in chaptersData) {
      // Create chapter number
      textItems.add(ReaderTextItems.chapterHeading(chapter['chapterNumber'], context));

      //log(chapter.toString());
      // At this point we don't know what the datatype is going to be
      for (var chapterContents in chapter["contents"]) {
        //log(chapterContents.toString());

        if (chapterContents is List<dynamic>) {
          if (chapterContents[0] is Map<String, dynamic>) {
            //log(chapterContents[0].toString());
            textItems.add(ReaderTextItems.sectionHeading(chapterContents[0]["s1"][0], context));
          }
        } else if (chapterContents is Map<String, dynamic>) {
          for (String key in chapterContents.keys) {
            //log(key.toString());
            if (key == "verseNumber") {
              textItems.add(ReaderTextItems.verseNumber(chapterContents[key], context));
            } else if (key == "verseText") {
              // Note: we remove Strongs numbers for now
              textItems.add(ReaderTextItems.verseText(chapterContents[key].replaceAll(RegExp(r"¦([0-9])\w+"), ''), context));

              textItems.add(ReaderTextItems.verseLinkText('G5676', (context){log('hello');}, context));
            }
          }
        }
      }
    }
    return textItems;
  }


  /// 
  List<InlineSpan> buildReaderTextSpans(Map<String, dynamic> jsonData, BuildContext context) {
    List<InlineSpan> spans = [];

    for (var item in buildTextItemsFromJson(jsonData, context)) {

      // Add space between chapters
      if (item.type == TextItemType.chapterHeading && item.text != ('Chapter 1')) {
        spans.add(const WidgetSpan(
          alignment: PlaceholderAlignment.top,
          baseline: TextBaseline.alphabetic,
          child: SizedBox(height: 50)
        ));
      } 

      TextSpan span;
      if (item.callback == null) {
        span = TextSpan(
          text: item.text,
          style: item.style,
        );
      } else {
        // Link
        span = TextSpan(
          text: item.text,
          style: item.style,
          recognizer: TapGestureRecognizer()..onTap = () => item.callback!(context),
        );
      }

      if (item.type == TextItemType.verseNumber) {
        // Add space between verses
        spans.add(const WidgetSpan(
          alignment: PlaceholderAlignment.top,
          baseline: TextBaseline.alphabetic,
          child: SizedBox(height: 30)
        ));
      }

      spans.add(span);
    }
    return spans;
  }
}