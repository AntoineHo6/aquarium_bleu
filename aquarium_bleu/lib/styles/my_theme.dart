import 'package:flutter/material.dart';

class MyTheme {
  static const seedColor = const Color(0xFF5B82C2);
  static const wcColor = Colors.lightBlue;
  static const paramColor = Color.fromRGBO(255, 152, 0, 1);

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: seedColor,
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: seedColor,
  );
}
