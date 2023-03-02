import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode;
  final Map _visibleParam;

  SettingsProvider(this._themeMode, this._visibleParam);

  getThemeMode() => _themeMode;
  getVisibleParameters() => _visibleParam;

  setThemeMode(ThemeMode mode, bool isDarkMode) async {
    _themeMode = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  setVisibleParam(String param, bool isVisible) async {
    _visibleParam[param] = isVisible;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(param, isVisible);
    notifyListeners();
  }
}
