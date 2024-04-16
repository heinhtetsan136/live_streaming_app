import 'package:flutter/material.dart';
import 'package:live_streaming/themes/theme.dart';

class AppLightTheme extends AppStandardTheme {
  @override
  Color get scaffoldBgColor => const Color.fromRGBO(239, 239, 243, 1);

  @override
  Color get scaffoldFgColor => const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color get selectedColor => const Color.fromRGBO(254, 44, 85, 1);

  @override
  Color get unselectedColor => const Color.fromRGBO(149, 149, 149, 1);

  @override
  Color get cardBgColor => scaffoldFgColor;

  @override
  Color get containerBgColor => selectedColor;

  @override
  Color get containerFgColor => scaffoldFgColor;

  @override
  Color get textColor => const Color.fromRGBO(0, 0, 0, 1);

  @override
  ThemeData get ref => ThemeData.light();
}

class AppDarkTheme extends AppStandardTheme {
  @override
  Color get scaffoldBgColor => const Color.fromRGBO(0, 0, 0, 1);

  @override
  Color get scaffoldFgColor => const Color.fromRGBO(28, 28, 29, 1);

  @override
  Color get selectedColor => const Color.fromRGBO(254, 44, 85, 1);

  @override
  Color get unselectedColor => const Color.fromRGBO(130, 130, 130, 1);

  @override
  Color get cardBgColor => scaffoldFgColor;

  @override
  Color get containerBgColor => selectedColor;

  @override
  ThemeData get ref => ThemeData.light().copyWith(
        brightness: Brightness.dark,
      );
}
