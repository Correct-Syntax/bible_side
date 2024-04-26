import 'package:flutter/material.dart';

import '../../../../common/themes.dart';
import '../../../../models/text_item.dart';

InlineSpan headingSectionSpan(
  BuildContext context,
  String verseText,
  String chapterReference,
  String verseReference,
  String sectionText,
) {
  return WidgetSpan(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                verseReference.trim() == '1'
                    ? TextSpan(
                        text: '$chapterReference ',
                        style: TextItemStyles.chapterHeading(context),
                      )
                    : const TextSpan(text: ''),
                TextSpan(
                  text: verseReference,
                  style: TextItemStyles.bodyMedium(context),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: verseText,
                  style: TextItemStyles.text(context),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: context.theme.appColors.readerText),
            ),
            padding: const EdgeInsets.all(4.0),
            margin: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: RichText(
                    text: TextSpan(
                      text: '${chapterReference.trim()}:${verseReference.trim()}',
                      style: TextItemStyles.bodyMedium(context),
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: sectionText,
                      style: TextItemStyles.sectionHeading(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

InlineSpan spacerSpan() {
  return const WidgetSpan(
    alignment: PlaceholderAlignment.top,
    baseline: TextBaseline.alphabetic,
    child: SizedBox(height: 30),
  );
}

InlineSpan largeSpacerSpan() {
  return const WidgetSpan(
    alignment: PlaceholderAlignment.top,
    baseline: TextBaseline.alphabetic,
    child: SizedBox(height: 50),
  );
}
