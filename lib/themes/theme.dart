import 'package:flutter/material.dart';

abstract class AppStandardTheme {
  Color get scaffoldBgColor;

  Color get scaffoldFgColor;

  Color get selectedColor;

  Color get unselectedColor;

  Color get containerBgColor;

  Color get cardBgColor;

  Color get containerFgColor => Colors.white;

  Color get textColor => Colors.white;

  ThemeData get ref;

  ThemeData get theme => ref.copyWith(
        scaffoldBackgroundColor: scaffoldBgColor,
        appBarTheme: AppBarTheme(
          backgroundColor: scaffoldFgColor,
          foregroundColor: textColor,
        ),
        cardTheme: CardTheme(
          shape: const RoundedRectangleBorder(),
          color: cardBgColor,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: scaffoldFgColor,
          selectedItemColor: textColor,
          unselectedItemColor: unselectedColor,
        ),
        textTheme: ref.textTheme.copyWith(
          bodyLarge: TextStyle(color: textColor),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: scaffoldFgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: selectedColor,
        ),
        cardColor: containerBgColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: selectedColor,
          foregroundColor: containerFgColor,
        ),
      );
}
