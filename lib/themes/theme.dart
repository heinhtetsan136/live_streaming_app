import 'package:flutter/material.dart';

abstract class AppStandardTheme {
  Color get scaffoldBgColor;

  Color get acitveColor;
  Color get unselectedColor;
  Color get bottomNavBgColor;

  Color get cardColor;
  Color get cardFgColor;

  Color get textColor => Colors.white;

  ThemeData get ref;

  ThemeData get theme => ref.copyWith(
        scaffoldBackgroundColor: scaffoldBgColor,
        cardTheme: CardTheme(
          shape: const RoundedRectangleBorder(),
          color: cardFgColor,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: bottomNavBgColor,
          selectedItemColor: acitveColor,
          unselectedItemColor: unselectedColor,
        ),
        cardColor: cardColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: acitveColor,
          foregroundColor: textColor,
        ),
      );
}
