import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode;
  final Map<String, bool> _visibleParams;

  SettingsProvider(this._themeMode, this._visibleParams);

  getThemeMode() => _themeMode;
  Map<String, bool> getVisibleParams() => _visibleParams;

  setThemeMode(ThemeMode mode, bool isDarkMode) async {
    _themeMode = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  setVisibleParam(String param, bool isVisible) async {
    _visibleParams[param] = isVisible;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(param, isVisible);
    notifyListeners();
  }
}
