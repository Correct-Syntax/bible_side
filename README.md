![Bibleside](/assets/images/logo-banner.jpg)

Bibleside is a simple, offline Bible app inspired by the Material 3 design system, featuring the OET.

The [OET (Open English Translation)](https://openenglishtranslation.bible) is a new, open-licensed Bible translation (currently in ``draft`` state) featuring multiple versions intended to be used together. <sup>Please see the OET website for more info on what makes it different than other translations.</sup>

Bibleside implements the OET's "Reader's" version in the main area and a toggle to show the "Literal" and "Reader's" versions side-by-side. The two can be scrolled together for easy comparison.


## Features

- [x] Runs fully offline
- [x] Two reader areas that can be scrolled together, side-by-side.
- [x] Light and dark modes


## Bible versions

- [x] Open English Translation [Readers Version](https://openenglishtranslation.bible/Design/ReadersVersion)
- [x] Open English Translation [Literal Version](https://openenglishtranslation.bible/Design/LiteralVersion)
- [x] King James Version


## Known issues

- Bug: Scrolling between the two versions is synced too well? Since the Literal version is lengthier, verses can be in different locations or even off screen.
- Inner sections of the Reader's version are misaligned.


## Feedback/contributing

Feedback and contributions are welcome. To help out please open an issue.


## Development

Bibleside is built with Flutter using [Stacked Architecture](https://stacked.filledstacks.com/).

- Run ``flutter pub get`` to install the dependencies.
- Choose an emulator or a connected device.
- Hit ``F5`` to run the code in the emulator.


## Note on Bible versions

Bible versions are treated as separate Bibles. e.g: The OET-RV and OET-LV are treated as a separate bible version.


## OET file conversion

There is a Python script in ``/assets/bibles`` that will automatically update the json files from the GitHub sources.

The ESFM files from [here (OET Reader's version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/translatedTexts/ReadersVersion) and [here (OET Literal version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/intermediateTexts/auto_edited_VLT_ESFM) are run through [usfm-grammar](https://github.com/Bridgeconn/usfm-grammar) in ``relaxed`` mode for conversion to JSON.

Navigate to ``/assets/bibles`` and run the file with ``python update_OET_json.py``.


## Updating the OET sections

After converting the OET ESFM to json, navigate to ``/assets/bibles`` and run the ``update_OET_sections.py`` file. This will generate a .dart file mapping of the OET sections for use in Bibleside.


## License

Bibleside is licensed under the GPL-3.0 license. See LICENSE for more information.