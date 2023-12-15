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

import '../core/bibles.dart';


/// Valid types determining how to divide the reader text.
enum ReaderType {
  verse,
  paragraph
}


/// The Base [TextItem] structure used as an intermediate format 
/// for different input data structures.
/// 
/// [TextItem] represents the content and visual style of a certain type of text. See [TextItemType].
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
  newParagraph,
}


/// [TextItem] styles
class TextItemStyles {

  static TextStyle bookHeading(context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500);
  }

  static TextStyle chapterHeading(context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500);
  }

  static TextStyle sectionHeading(context) {
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

  final ReaderType readerType; // UNUSED: can specify a reader type for styling specific to that reader


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
      style: TextItemStyles.sectionHeading(context)
    );
  }

  static TextItem verseNumber(String verseNumber, BuildContext context) {
    return TextItem(
      text: ' $verseNumber ',
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

  static TextItem newParagraph(BuildContext context) {
    return TextItem(
      text: '\n',
      type: TextItemType.newParagraph,
      style: TextItemStyles.text(context)
    );
  }
}



class ReaderContentBuilder {

  /// Builds a list of [RichText] [TextSpan]s based on [jsonData]. 
  /// If [splitByParagraph] is true, the text will be split by paragraph instead of by verse.
  List<InlineSpan> buildReaderTextSpans(Map<String, dynamic> jsonData, BuildContext context, bool splitByParagraph) {
    List<InlineSpan> spans = [];
    WidgetSpan spacer = const WidgetSpan(
      alignment: PlaceholderAlignment.top,
      baseline: TextBaseline.alphabetic,
      child: SizedBox(height: 30)
    );
    WidgetSpan largeSpacer = const WidgetSpan(
      alignment: PlaceholderAlignment.top,
      baseline: TextBaseline.alphabetic,
      child: SizedBox(height: 50)
    );

    List<TextItem> textItems = buildTextItemsFromJson(BibleVersion.theOET, jsonData, context, splitByParagraph);

    // Convert TextItems to RichText TextSpans
    for (var item in textItems) {

      // Add space between chapters
      if (item.type == TextItemType.chapterHeading && item.text != ('Chapter 1')) {
        spans.add(largeSpacer);
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

      if (splitByParagraph == true) {
        // Add the space between paragraphs
        if (item.type == TextItemType.newParagraph) {
          spans.add(spacer);
        }
      } else {
        // Add the space between verses
        if (item.type == TextItemType.verseNumber) {
          spans.add(spacer);
        }
      }
      spans.add(span);
    }
    return spans;
  }


  /// Creates the TextItems from the given json data using a specific version implementation.
  /// 
  /// This method can have multiple versions, each with their own 
  /// specific json data to TextItems implementation:
  /// ```if (..) {
  ///   return buildTextItemsFromKJVJson(json, context, splitByParagraph);
  /// } else if (..) {
  ///   return buildTextItemsFromOETJson(json, context, splitByParagraph);
  /// }```
  List<TextItem> buildTextItemsFromJson(BibleVersion version, Map<String, dynamic> json, BuildContext context, bool splitByParagraph) {
    if (version == BibleVersion.theOET) {
      return buildTextItemsFromOETJson(json, context, splitByParagraph);
    } else {
      return [];
    }
  }


  /// This is the OET-specific implementation of building a list of [TextItems] from the [json].
  /// The json data is expected to be from the OET, otherwise it will error.
  List<TextItem> buildTextItemsFromOETJson(Map<String, dynamic> json, BuildContext context, bool splitByParagraph) {
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
    for (Map<String, dynamic> chapter in chaptersData) {
      bool isNewParagraph = false;

      // Handle chapters
      String chapterText = chapter['chapterNumber'];
      textItems.add(ReaderTextItems.chapterHeading(chapterText, context));
      if (splitByParagraph == true) {
        textItems.add(ReaderTextItems.newParagraph(context));
      }
      
      // Handle chapter contents
      // At this point we don't know what the datatype is going to be
      for (var chapterContents in chapter["contents"]) {
        //log(chapterContents.toString());

        if (chapterContents is List<dynamic>) {
          
        } else if (chapterContents is Map<String, dynamic>) {
          for (String key in chapterContents.keys) {

            // Handle chapter section headings
            if (key == 's1') {
              //log(chapterContents.toString());
              textItems.add(ReaderTextItems.sectionHeading(chapterContents["s1"], context));
            }

            // Handle new paragraphs
            if (key == "contents") {
              if (splitByParagraph == true) {
                // We're looking for the indication of a new paragraph: "p" representing /p in the ESFM
                for (var innerMap in chapterContents[key]) {
                  if (innerMap is Map) {
                    //log(innerMap.toString());
                    if (innerMap.containsKey("p")) {
                      isNewParagraph = true;
                    }
                  }
                }
              }
            }

            // Handle verse numbers
            if (key == "verseNumber") {
              String verseNumberText = chapterContents[key];

              // Verse numbers can either be th beginning of a verse or, in splitByParagraph
              // mode, potentially the beginning of a paragraph.
              if (isNewParagraph == true) {
                // Add a new break between paragraphs
                textItems.add(ReaderTextItems.newParagraph(context));
                isNewParagraph = false;
              } else {
                if (splitByParagraph != true) {
                  // Add newline between each verse
                  verseNumberText = "\n$verseNumberText"; 
                }
              }
              textItems.add(ReaderTextItems.verseNumber(verseNumberText, context));

            // Handle verse text
            } else if (key == "verseText") {         
              // Note: we remove Strongs numbers for now
              textItems.add(ReaderTextItems.verseText(chapterContents[key].replaceAll(RegExp(r"¦([0-9])\w+"), ''), context));

              //textItems.add(ReaderTextItems.verseLinkText('G5676', (context){log('hello');}, context));
            } 
          }
        }
      }
    }
    return textItems;
  }
}