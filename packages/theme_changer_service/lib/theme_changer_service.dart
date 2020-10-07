library theme_changer_service;

import 'package:flutter/material.dart';

class ThemeConfiguration {
  final Color primaryColor;
  final Color accentColor;

  ThemeConfiguration({
    @required this.primaryColor,
    @required this.accentColor,
  });
}

class ThemeChangerService with ChangeNotifier {
  final String name;
  ThemeData _themeData;
  String _themeName;

  ThemeChangerService({this.name}) {
    generateTheme(name);
  }

  Map<String, Object> _themeMap = {
    'Dark Pink': ThemeConfiguration(
      primaryColor: HexColor.fromHex('#870d4c'),
      accentColor: HexColor.fromHex('#eeff41'),
    ),
    'Dark Teal': ThemeConfiguration(
      primaryColor: HexColor.fromHex('#006064'),
      accentColor: HexColor.fromHex('#a7ffeb'),
    ),
  };

  void generateTheme(String themeName) {
    ThemeConfiguration config = _themeMap[themeName];
    this._themeName = themeName;
    if (config != null) {
      this._themeData = ThemeData.light().copyWith(
        primaryColor: config.primaryColor,
        accentColor: config.accentColor,
      );
    } else if (themeName == 'Dark') {
      this._themeData = ThemeData.dark();
    } else {
      this._themeData = ThemeData.light();
    }
  }

  getThemeName() {
    return this._themeName;
  }

  getTheme() {
    return _themeData;
  }

  setTheme(String themeName) {
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
