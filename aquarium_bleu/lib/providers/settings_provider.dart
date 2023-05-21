import 'package:aquarium_bleu/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode? themeMode;
  String? lastSelectedParam;

  SettingsProvider(String themeStr, this.lastSelectedParam) {
    switch (themeStr) {
      case Strings.system:
        themeMode = ThemeMode.system;
        break;
      case Strings.light:
        themeMode = ThemeMode.light;
        break;
      default:
        themeMode = ThemeMode.dark;
    }
  }

  setThemeMode(ThemeMode mode, String themeStr) async {
    themeMode = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(Strings.theme, themeStr);
    notifyListeners();
  }

  setLastSelectedParam(String newParam) async {
    lastSelectedParam = newParam;
    var prefs = await SharedPreferences.getInstance();
    // maybe set it to a string "none" instead
    prefs.setString(Strings.lastSelectedParam, newParam);
    notifyListeners();
  }
}
