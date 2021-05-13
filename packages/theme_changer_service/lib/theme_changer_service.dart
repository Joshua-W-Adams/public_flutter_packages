library theme_changer_service;

import 'package:flutter/material.dart';

class ThemeConfiguration {
  final String baseTheme;
  final Color? primaryColor;
  final Color? accentColor;

  ThemeConfiguration({
    required this.baseTheme,
    this.primaryColor,
    this.accentColor,
  }) : assert(
          ['light', 'dark'].contains(baseTheme),
          'base theme must be light or dark',
        );
}

class ThemeChangerService with ChangeNotifier {
  final String name;

  ThemeChangerService({required this.name}) {
    generateTheme(name);
  }

  ThemeData? _themeData;
  String? _themeName;

  Map<String, ThemeConfiguration> _supportedThemes = {
    'Light': ThemeConfiguration(
      baseTheme: 'light',
    ),
    'Dark': ThemeConfiguration(
      baseTheme: 'dark',
    ),
    'Dark Pink': ThemeConfiguration(
      baseTheme: 'light',
      primaryColor: HexColor.fromHex('#870d4c'),
      accentColor: HexColor.fromHex('#eeff41'),
    ),
    'Dark Teal': ThemeConfiguration(
      baseTheme: 'light',
      primaryColor: HexColor.fromHex('#006064'),
      accentColor: HexColor.fromHex('#a7ffeb'),
    ),
  };

  ThemeData _generateTheme(ThemeConfiguration themeConfiguration) {
    Color? primaryColour = themeConfiguration.primaryColor;
    ThemeData baseThemeData;

    if (themeConfiguration.baseTheme == 'light') {
      baseThemeData = ThemeData.light();
    } else {
      baseThemeData = ThemeData.dark();
    }

    Color? textSelectionColor = primaryColour != null
        ? ColorFunctions.getContrastingShadeColor(primaryColour)
        : ColorFunctions.getContrastingShadeColor(baseThemeData.primaryColor);

    return baseThemeData.copyWith(
      primaryColor: primaryColour,
      accentColor: themeConfiguration.accentColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: textSelectionColor,
        selectionColor: textSelectionColor,
        selectionHandleColor: textSelectionColor,
      ),
    );
  }

  void generateTheme(String themeName) {
    ThemeConfiguration? config = _supportedThemes[themeName];
    this._themeName = themeName;
    if (config != null) {
      this._themeData = _generateTheme(config);
    } else {
      this._themeData = ThemeData.light();
    }
  }

  String? getThemeName() {
    return this._themeName;
  }

  ThemeData? getTheme() {
    return _themeData;
  }

  void setTheme(String themeName) {
    generateTheme(themeName);
    // notifiy listeners to force a rebuild
    notifyListeners();
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${alpha.toRadixString(16).padLeft(2, '0')}'
        '${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

abstract class ColorFunctions {
  static Color getContrastingShadeColor(Color color) {
    /// determine luminance (brightness). 0 = black, 1 = white.
    double lum = color.computeLuminance();

    /// percentage modifier for constrasting color brightness
    double modifier = 0.5;

    /// return values based on bg luminance
    if (lum >= 0.75) {
      /// case 1 - super bright color
      modifier = 0.5;
    } else if (lum >= 0.675) {
      /// case 2 - bright color
      modifier = 0.375;
    } else if (lum >= 0.5) {
      /// case 3 - somewhat bright color
      modifier = 0.25;
    } else if (lum >= 0.375) {
      /// case 4 - somewhat dark color
      modifier = 1.75;
    } else if (lum >= 0.25) {
      /// case 5 - dark color
      modifier = 2.25;
    } else {
      /// case 6 - really dark color
      modifier = 2.5;
    }

    return changeColorLightness(color, lum * modifier);
  }

  /// lightness. 0 = black, 1 = white.
  static Color changeColorLightness(Color color, double lightness) {
    return HSLColor.fromColor(color).withLightness(lightness).toColor();
  }
}
