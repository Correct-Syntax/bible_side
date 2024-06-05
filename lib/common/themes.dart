import 'package:flutter/material.dart';

abstract class ReaderTextPalette {
  // Red letters for Words of the Messiah
  static const redLetterRed = Color(0xFFC24545);

  // Add article +
  static const addArticleOrange = Color(0xFFCB9169);

  // Add extra >
  static const addExtraGreen = Color(0xFF5EC651);

  // Add copula =
  static const addCopulaPink = Color(0xFFC260B1);

  // Add unused -

  // Add direct object ~

  // Add owner ^
}

abstract class LightThemePalette {
  // White
  static const white = Color(0xFFFFFFFF);

  // White 70% opacity
  static const white70 = Color.fromRGBO(255, 255, 255, 0.7);

  // Light blue
  static const lightBlue = Color(0xFFDAEDFC);

  // Medium blue
  static const mediumBlue = Color(0xFF1F3D57);

  // Dark blue
  static const darkBlue = Color(0xFF193247);

  // Medium gray
  static const mediumSlate = Color(0xFF515358);

  // Medium gray 10%
  static const mediumSlate10 = Color.fromRGBO(81, 83, 88, 0.1);

  // Medium-dark gray
  static const mediumDarkSlate = Color(0xFF414548);
}

abstract class DarkThemePalette {
  // White
  static const white = Color(0xFFFFFFFF);

  // White 10% opacity
  static const white10 = Color.fromRGBO(255, 255, 255, 0.1);

  // White 70% opacity
  static const white70 = Color.fromRGBO(255, 255, 255, 0.7);

  // Medium-light gray
  static const mediumLightGray = Color(0xFFA9ADB1);

  // Dark grey
  static const darkGray = Color(0xFF1F2123);

  // Dark black gray
  static const almostBlack = Color(0xFF161718);
}

abstract class SepiaThemePalette {
  // White
  static const white = Color(0xFFFFFFFF);

  // Almost white tan
  static const almostWhiteTan = Color(0xFFFBF8E9);

  // Light tan
  static const lightTan = Color(0xFFEBDFC7);

  // Medium brown
  static const mediumBrown = Color(0xFF8E8367);

  // Medium-dark brown
  static const mediumDarkBrown = Color(0xFF655F49);

  // Medium gray
  static const mediumGray = Color(0xFF5E6166);

  // Medium-dark gray
  static const mediumDarkGray = Color(0xFF414546);
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    required this.primary,
    required this.secondary,
    required this.primaryOnDark,
    required this.secondaryOnDark,
    required this.primaryIcon,
    required this.secondaryIcon,
    required this.appbarIcon,
    required this.background,
    required this.appbarBackground,
    required this.popupBackground,
    required this.readerSelectorBackground,
    required this.switchBackground,
    required this.sliderAccent,
    required this.divider,
    required this.readerText,
    required this.readerRedLetter,
    required this.readerAddArticle,
    required this.readerAddExtra,
    required this.addCopulaPink,
  });

  final Color primary;
  final Color secondary;
  final Color primaryOnDark;
  final Color secondaryOnDark;
  final Color primaryIcon;
  final Color secondaryIcon;
  final Color appbarIcon;
  final Color background;
  final Color appbarBackground;
  final Color popupBackground;
  final Color readerSelectorBackground;
  final Color switchBackground;
  final Color sliderAccent;
  final Color divider;
  final Color readerText;
  final Color readerRedLetter;
  final Color readerAddArticle;
  final Color readerAddExtra;
  final Color addCopulaPink;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? c,
  }) {
    return AppColorsExtension(
      primary: primary,
      secondary: secondary,
      primaryOnDark: primaryOnDark,
      secondaryOnDark: secondaryOnDark,
      primaryIcon: primaryIcon,
      secondaryIcon: secondaryIcon,
      appbarIcon: appbarIcon,
      background: background,
      appbarBackground: appbarBackground,
      popupBackground: popupBackground,
      readerSelectorBackground: readerSelectorBackground,
      switchBackground: switchBackground,
      sliderAccent: sliderAccent,
      divider: divider,
      readerText: readerText,
      readerRedLetter: readerRedLetter,
      readerAddArticle: readerAddArticle,
      readerAddExtra: readerAddExtra,
      addCopulaPink: addCopulaPink,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      primaryOnDark: Color.lerp(primaryOnDark, other.primaryOnDark, t)!,
      secondaryOnDark: Color.lerp(secondaryOnDark, other.secondaryOnDark, t)!,
      primaryIcon: Color.lerp(primaryIcon, other.primaryIcon, t)!,
      secondaryIcon: Color.lerp(secondaryIcon, other.secondaryIcon, t)!,
      appbarIcon: Color.lerp(appbarIcon, other.appbarIcon, t)!,
      background: Color.lerp(background, other.background, t)!,
      appbarBackground: Color.lerp(appbarBackground, other.appbarBackground, t)!,
      popupBackground: Color.lerp(popupBackground, other.popupBackground, t)!,
      readerSelectorBackground: Color.lerp(readerSelectorBackground, other.readerSelectorBackground, t)!,
      switchBackground: Color.lerp(switchBackground, other.switchBackground, t)!,
      sliderAccent: Color.lerp(sliderAccent, other.sliderAccent, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      readerText: Color.lerp(readerText, other.readerText, t)!,
      readerRedLetter: Color.lerp(readerRedLetter, other.readerRedLetter, t)!,
      readerAddArticle: Color.lerp(readerAddArticle, other.readerAddArticle, t)!,
      readerAddExtra: Color.lerp(readerAddExtra, other.readerAddExtra, t)!,
      addCopulaPink: Color.lerp(addCopulaPink, other.addCopulaPink, t)!,
    );
  }
}

class AppTheme {
  // Light theme
  static final light = ThemeData.light().copyWith(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Color(0xFF96BAD9),
      selectionHandleColor: LightThemePalette.mediumBlue,
    ),
    extensions: [
      _lightAppColors,
    ],
  );

  static final _lightAppColors = AppColorsExtension(
    primary: LightThemePalette.mediumSlate,
    secondary: LightThemePalette.mediumSlate,
    primaryOnDark: LightThemePalette.white,
    secondaryOnDark: LightThemePalette.white70,
    primaryIcon: LightThemePalette.white,
    secondaryIcon: LightThemePalette.white,
    appbarIcon: LightThemePalette.white,
    background: LightThemePalette.white,
    appbarBackground: LightThemePalette.mediumBlue,
    popupBackground: LightThemePalette.mediumBlue,
    readerSelectorBackground: LightThemePalette.darkBlue,
    switchBackground: LightThemePalette.mediumBlue,
    sliderAccent: LightThemePalette.mediumBlue,
    divider: LightThemePalette.mediumSlate10,
    readerText: LightThemePalette.mediumSlate,
    readerRedLetter: ReaderTextPalette.redLetterRed,
    readerAddArticle: ReaderTextPalette.addArticleOrange,
    readerAddExtra: ReaderTextPalette.addExtraGreen,
    addCopulaPink: ReaderTextPalette.addCopulaPink,
  );

  // Dark theme
  static final dark = ThemeData.dark().copyWith(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Color(0xFF444748),
      selectionHandleColor: Colors.white,
    ),
    extensions: [
      _darkAppColors,
    ],
  );

  static final _darkAppColors = AppColorsExtension(
    primary: DarkThemePalette.white,
    secondary: DarkThemePalette.white70,
    primaryOnDark: DarkThemePalette.white,
    secondaryOnDark: DarkThemePalette.white70,
    primaryIcon: DarkThemePalette.white,
    secondaryIcon: DarkThemePalette.white,
    appbarIcon: DarkThemePalette.white,
    background: DarkThemePalette.darkGray,
    appbarBackground: DarkThemePalette.almostBlack,
    popupBackground: DarkThemePalette.almostBlack,
    readerSelectorBackground: DarkThemePalette.darkGray,
    switchBackground: DarkThemePalette.white,
    sliderAccent: DarkThemePalette.white,
    divider: DarkThemePalette.white10,
    readerText: DarkThemePalette.mediumLightGray,
    readerRedLetter: ReaderTextPalette.redLetterRed,
    readerAddArticle: ReaderTextPalette.addArticleOrange,
    readerAddExtra: ReaderTextPalette.addExtraGreen,
    addCopulaPink: ReaderTextPalette.addCopulaPink,
  );

  // Sepia theme
  static final sepia = ThemeData.light().copyWith(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Color(0xFF96BAD9),
      selectionHandleColor: LightThemePalette.mediumBlue,
    ),
    extensions: [
      _sepiaAppColors,
    ],
  );

  static final _sepiaAppColors = AppColorsExtension(
    primary: SepiaThemePalette.mediumDarkBrown,
    secondary: SepiaThemePalette.mediumBrown,
    primaryOnDark: SepiaThemePalette.mediumDarkBrown,
    secondaryOnDark: SepiaThemePalette.mediumDarkBrown,
    primaryIcon: SepiaThemePalette.mediumDarkBrown,
    secondaryIcon: SepiaThemePalette.mediumBrown,
    appbarIcon: SepiaThemePalette.mediumDarkBrown,
    background: SepiaThemePalette.almostWhiteTan,
    appbarBackground: SepiaThemePalette.lightTan,
    popupBackground: SepiaThemePalette.lightTan,
    readerSelectorBackground: SepiaThemePalette.almostWhiteTan,
    switchBackground: SepiaThemePalette.mediumBrown,
    sliderAccent: SepiaThemePalette.mediumBrown,
    divider: SepiaThemePalette.lightTan,
    readerText: SepiaThemePalette.mediumGray,
    readerRedLetter: ReaderTextPalette.redLetterRed,
    readerAddArticle: ReaderTextPalette.addArticleOrange,
    readerAddExtra: ReaderTextPalette.addExtraGreen,
    addCopulaPink: ReaderTextPalette.addCopulaPink,
  );
}

extension AppThemeExtension on ThemeData {
  AppColorsExtension get appColors => extension<AppColorsExtension>() ?? AppTheme._lightAppColors;
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}
