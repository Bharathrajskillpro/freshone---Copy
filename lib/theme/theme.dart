import 'package:flutter/material.dart';

import 'colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDark => themeMode == ThemeMode.dark;

  void toggleTheme(bool ison) {
    themeMode = ison ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  iconColor() => isDark ? colors.navbarIconIADark : colors.navbarIconIALight;
}

class themeShifter {
  static final darktheme = ThemeData(
      dialogTheme: const DialogTheme(
    backgroundColor: Color.fromRGBO(239, 241, 255, 1),
  ));

  static final lighttheme = ThemeData(
      dialogTheme: const DialogTheme(
    backgroundColor: Color.fromRGBO(48, 40, 76, 1),
  ));
}
