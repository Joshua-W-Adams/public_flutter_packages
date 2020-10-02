library theme_changer_service;

import 'package:flutter/material.dart';

class ThemeChangerService with ChangeNotifier {
  final String name;
  ThemeData _themeData;
  String _themeName;

  ThemeChangerService({this.name}) {
    generateTheme(name);
  }

  // themes currently supported
  void generateTheme(String themeName) {
    if (themeName == "dark") {
      this._themeName = "dark";
      this._themeData = ThemeData.dark();
    } else {
      this._themeName = "light";
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
