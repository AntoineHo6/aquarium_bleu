import 'package:aquarium_bleu/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode themeMode;
  // final Map<String, bool> visibleParams;
  String lastSelectedParam;
  String waterParamDateRange;

  SettingsProvider(
    this.themeMode,
    // this.visibleParams,
    this.lastSelectedParam,
    this.waterParamDateRange,
  );

  setThemeMode(ThemeMode mode, bool isDarkMode) async {
    themeMode = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(Strings.isDarkMode, isDarkMode);
    notifyListeners();
  }

  setVisibleParam(String param, bool isVisible) async {
    // visibleParams[param] = isVisible;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(param, isVisible);
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
