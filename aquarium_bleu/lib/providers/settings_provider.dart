import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode;

  SettingsProvider(this._themeMode);

  getThemeMode() => _themeMode;

  setThemeMode(ThemeMode mode, bool isDarkMode) async {
    _themeMode = mode;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }
}
