import 'package:aquarium_bleu/styles/myColors.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.black02dp,
    ),
    scaffoldBackgroundColor: DarkThemeColors.black00dp,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xff4D82B2),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );
}
