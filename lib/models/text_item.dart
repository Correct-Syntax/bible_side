import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../common/themes.dart';

/// Valid types determining how to divide the reader text.
enum ReaderType { verse, paragraph }

/// The Base [TextItem] structure used as an intermediate format
/// for different input data structures.
///
/// [TextItem] represents the content and visual style of a certain type of text. See [TextItemType].
class TextItem {
  final String text;
  final TextItemType type;
  //final TextStyle style;
  final void Function(BuildContext)? callback;

  TextItem({
    required this.text,
    required this.type,
    //required this.style,
    this.callback,
  });
}

/// Valid types describing a [TextItem]
enum TextItemType {
  bookHeading,
  chapterHeading,
  sectionHeading,
  sectionVerseReference,
  verseNumber,
  verseText,
  verseLink,
  newParagraph,
}

/// [TextItem] styles
class TextItemStyles {
  static TextStyle bookHeading(BuildContext context) {
    return TextStyle(
      color: context.theme.appColors.readerText,
      fontFamily: 'Merriweather',
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle chapterHeading(BuildContext context) {
    return TextStyle(
      color: context.theme.appColors.readerText,
      fontFamily: 'Merriweather',
      fontSize: 26.0,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle sectionHeading(BuildContext context) {
    return TextStyle(
      color: context.theme.appColors.readerText,
      fontFamily: 'Merriweather',
      fontSize: 17.0,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      color: context.theme.appColors.readerText,
      fontSize: 11.0,
    );
  }

  static TextStyle text(BuildContext context) {
    return TextStyle(
      color: context.theme.appColors.readerText,
      fontFamily: 'Merriweather',
      fontSize: 15.0,
      letterSpacing: 0.3,
      height: 1.7,
    );
  }

  static TextStyle link(context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.blue);
  }
}

/// TextItems
class ReaderTextItems {
  ReaderTextItems(this.readerType);

  final ReaderType readerType; // UNUSED: can specify a reader type for styling specific to that reader

  static TextItem bookHeading(String book) {
    return TextItem(
      text: book,
      type: TextItemType.bookHeading,
      //style: TextItemStyles.bookHeading(context)
    );
  }

  static TextItem chapterHeading(String chapter) {
    return TextItem(
      text: chapter,
      // text: chapter == '1'
      //     ? 'Chapter $chapter'
      //     : '\nChapter $chapter', // Add newline before all but the first chapter
      type: TextItemType.chapterHeading,
      //style: TextItemStyles.chapterHeading(context)
    );
  }

  static TextItem sectionHeading(String heading) {
    return TextItem(
      text: heading,
      type: TextItemType.sectionHeading,
      //style: TextItemStyles.sectionHeading(context)
    );
  }

  static TextItem verseNumber(String verseNumber) {
    return TextItem(
      text: verseNumber.trim(),
      type: TextItemType.verseNumber,
      //style: TextItemStyles.bodyMedium(context)
    );
  }

  static TextItem verseText(String verseText) {
    return TextItem(
      text: verseText,
      type: TextItemType.verseText,
      //style: TextItemStyles.text(context)
    );
  }

  static TextItem verseLinkText(String verseLink, Function onTap) {
    return TextItem(
      text: verseLink,
      type: TextItemType.verseLink,
      //style: TextItemStyles.link(context),
      callback: (context) {
        onTap(context);
        // TODO: remove
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You tapped the link'),
          ),
        );
      },
    );
  }

  static TextItem newParagraph() {
    return TextItem(
      text: '',
      type: TextItemType.newParagraph,
      //style: TextItemStyles.text(context)
    );
  }
}
