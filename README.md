# BibleSide

BibleSide is an offline Bible app inspired by Material 3 design system.

The goal is for multiple translations (KJV, etc) to be added in the future, but integrating the [OET (Open English Translation)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET) is the primary focus right now.

The OET is a new, open-licensed Bible translation (currently in ``draft`` state) featuring multiple versions intended to be used together. <sup>Please see the OET README for more info on what makes it different than other translations.</sup>

BibleSide currently implements the OET's "Reader's" version in the main area and a toggle to show the "Literal" and "Reader's" versions side-by-side. The two can be scrolled together for easy comparison. The layout and interface patterns are likely to evolve over time.

**Work in progress. Currently in a minimal prototype state.**


## TODO/Goals

- [ ] Add all the OET Bible books currently available  
- [ ] Light and dark modes
- [ ] Theme and text size customization
- [ ] Downplay the chapters and verses for the OET


## Known issues

- Bug: Closing and reopening the literal version bottom sheet causes the reader's version to scroll back to the start.
- Bug: Scrolling between the two versions is synced too well. Since the Literal version is lengthier, verses can be in different locations or even off screen.
- Missing feature: Currently only loads the book of Acts.
- Missing feature: Most buttons don't do anything.


## Feedback/Contributing

Feedback is welcome. To help out please open an issue.


## Development

BibleSide uses Flutter.

Build and run with

```bash
flutter run
```


## OET file conversion

Currently, the ESFM files from [here (OET Reader's version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/translatedTexts/ReadersVersion) and [here (OET Literal version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/intermediateTexts/auto_edited_VLT_ESFM) are run through [https://usfm-grammar-revant.netlify.app/](https://usfm-grammar-revant.netlify.app/) in ``relaxed`` mode for conversion to JSON.


## License

BibleSide is licensed under the GPL-3.0 license. See LICENSE for more information.