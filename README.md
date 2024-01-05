# Bibleside

Bibleside is a simple, offline Bible app inspired by the Material 3 design system, featuring the OET.

The goal is for multiple translations (KJV, etc) to be added in the future, but integrating the [OET (Open English Translation)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET) is the primary focus right now.

The OET is a new, open-licensed Bible translation (currently in ``draft`` state) featuring multiple versions intended to be used together. <sup>Please see the OET README for more info on what makes it different than other translations.</sup>

Bibleside implements the OET's "Reader's" version in the main area and a toggle to show the "Literal" and "Reader's" versions side-by-side. The two can be scrolled together for easy comparison. The layout and interface patterns are likely to evolve over time.


## Known issues

- Bug (or feature?): Closing and reopening the literal version bottom sheet causes the reader's version to scroll back to the start.
- Bug: Scrolling between the two versions is synced too well? Since the Literal version is lengthier, verses can be in different locations or even off screen.


## Feedback/contributing

Feedback and contributions are welcome. To help out please open an issue.


## Development

Bibleside is built with Flutter using Stacked Architecture.

- Run ``flutter pub get`` to install the dependencies.
- Choose an emulator or a connected device.
- Hit ``F5`` to run the code in the emulator.


## Note on Bible versions

Bible versions are treated as separate Bibles. e.g: The OET-RV and OET-LV are treated as a separate bible version.


## OET file conversion

There is a Python script in ``/assets/bibles`` that will automatically update the json files from the GitHub sources.

The ESFM files from [here (OET Reader's version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/translatedTexts/ReadersVersion) and [here (OET Literal version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/intermediateTexts/auto_edited_VLT_ESFM) are run through [usfm-grammar](https://github.com/Bridgeconn/usfm-grammar) in ``relaxed`` mode for conversion to JSON.

Navigate to ``/assets/bibles`` and run the file with ``python update_OET_json.py``.


## License

Bibleside is licensed under the GPL-3.0 license. See LICENSE for more information.