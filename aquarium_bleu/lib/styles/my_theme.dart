import 'package:aquarium_bleu/styles/my_colors.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.black02dp,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(DarkThemeColors.black06dp),
        overlayColor:
            MaterialStateProperty.all<Color>(DarkThemeColors.babyBlue.shade800),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: DarkThemeColors.black02dp,
      selectedItemColor: DarkThemeColors.babyBlue,
    ),
    scaffoldBackgroundColor: DarkThemeColors.black00dp,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DarkThemeColors.babyBlue,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all<Color>(DarkThemeColors.babyBlue),
      trackColor:
          MaterialStateProperty.all<Color>(DarkThemeColors.babyBlue.shade700),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  );
}
