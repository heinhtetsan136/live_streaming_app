import 'package:flutter/material.dart';
import 'package:live_streaming/themes/theme.dart';

class AppLightTheme extends AppStandardTheme {
  @override
  Color get scaffoldFgColor => const Color.fromRGBO(255, 255, 255, 1);
  @override
  Color get scaffoldBgColor => const Color.fromRGBO(239, 239, 243, 1);

  @override
  Color get acitveColor => const Color.fromRGBO(250, 18, 20, 1);

  @override
  Color get unselectedColor => const Color.fromRGBO(0, 0, 0, 0.8);

  @override
  Color get bottomNavBgColor => Colors.white;

  @override
  Color get cardColor => acitveColor;

  @override
  Color get cardFgColor => bottomNavBgColor;

  @override
  ThemeData get ref => ThemeData.light();
}

class AppDarkTheme extends AppStandardTheme {
  @override
  Color get scaffoldFgColor => const Color.fromRGBO(28, 28, 29, 1);
  @override
  Color get scaffoldBgColor => const Color.fromRGBO(255, 254, 253, 0.95);

  @override
  Color get acitveColor => const Color.fromRGBO(250, 18, 20, 1);

  @override
  Color get unselectedColor => const Color.fromRGBO(0, 0, 0, 0.8);

  @override
  Color get bottomNavBgColor => Colors.white;

  @override
  Color get cardColor => acitveColor;

  @override
  Color get cardFgColor => bottomNavBgColor;

  @override
  ThemeData get ref => ThemeData.dark();
}
