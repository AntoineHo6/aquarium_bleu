import 'package:aquarium_bleu/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode;
  final Map<String, bool> _visibleParams;
  String? _lastSelectedParam;

  SettingsProvider(
    this._themeMode,
    this._visibleParams,
    this._lastSelectedParam,
  );

  getThemeMode() => _themeMode;
  Map<String, bool> getVisibleParams() => _visibleParams;
  getLastSelectedParam() => _lastSelectedParam;

  setThemeMode(ThemeMode mode, bool isDarkMode) async {
    _themeMode = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(Strings.isDarkMode, isDarkMode);
    notifyListeners();
  }

  setVisibleParam(String param, bool isVisible) async {
    _visibleParams[param] = isVisible;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(param, isVisible);
    notifyListeners();
  }

  setLastSelectedParam(String? newParam) async {
    _lastSelectedParam = newParam;
    var prefs = await SharedPreferences.getInstance();
    // maybe set it to a string "none" instead
    prefs.setString(Strings.lastSelectedParam, newParam!);
    notifyListeners();
  }
}
