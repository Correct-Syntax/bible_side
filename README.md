![Bibleside](/assets/images/logo-banner.jpg)

Bibleside is an offline Bible app featuring the OET (Open English Translation).

The [OET (Open English Translation)](https://openenglishtranslation.bible) is a new, open-licensed Bible translation (currently in ``draft`` state) featuring multiple versions intended to be used together. <sup>Please see the OET website for more info on what makes it different than other translations.</sup>

Bibleside implements the OET's "Reader's" version in the main area and a toggle to show the "Literal" and "Reader's" versions side-by-side. The two can be scrolled together for easy comparison.


## Try the app

**Bibleside is currently in closed testing on Google Play. Signup [here](https://play.google.com/apps/testing/com.bibleside.bibleside) to become a tester and provide early alpha version feedback.**


## Bible versions

- [x] Open English Translation [Readers Version](https://openenglishtranslation.bible/Design/ReadersVersion)
- [x] Open English Translation [Literal Version](https://openenglishtranslation.bible/Design/LiteralVersion)
- [x] King James Version
- [ ] WEB (World English Bible)

Others?


## Known issues/TODO

- Bug: Scrolling between the two versions is synced too well? Since the Literal version is lengthier, verses can be in different locations or even off screen.
- Some sections are missing or have misplaced starting points (fix in update_OET_sections.py)


## Feedback/contributing

Feedback and contributions are welcome. To help out please open an issue.


## Development

Bibleside is built with Flutter using [Stacked Architecture](https://stacked.filledstacks.com/).

- Run ``flutter pub get`` to install the dependencies.
- Choose an emulator or a connected device.
- Hit ``F5`` to run the code in the emulator, or open and terminal and run with ``flutter run``.


## Note on Bible versions

Bible versions are treated as separate Bibles. e.g: The OET-RV and OET-LV are treated as a separate bible version.


## OET file conversion

There is a Python script in ``/assets/bibles`` that will automatically update the json files from the GitHub sources.

The ESFM files from [here (OET Reader's version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/translatedTexts/ReadersVersion) and [here (OET Literal version)](https://github.com/Freely-Given-org/OpenEnglishTranslation--OET/tree/main/intermediateTexts/auto_edited_VLT_ESFM) are run through [usfm-grammar](https://github.com/Bridgeconn/usfm-grammar) in ``relaxed`` mode for conversion to JSON.

Navigate to ``/assets/bibles`` and run the file with ``python update_OET_json.py``.


## Updating the OET sections

After converting the OET ESFM to json, navigate to the folder with ``cd assets/bibles`` and run ``python update_OET_sections.py``. This will generate two dart files mapping the OET sections for use in Bibleside. Move back to the root folder with ``cd ../..`` and run ``dart format ./lib -l 120`` to format the file.


## License

Bibleside is licensed under the GPL-3.0 license. See LICENSE for more information.