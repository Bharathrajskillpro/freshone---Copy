import 'package:flutter/material.dart';

// ignore: camel_case_types
class colors {
  // special gradient
  static LinearGradient gradiant = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromRGBO(233, 210, 149, 1),
        Color.fromRGBO(255, 170, 87, 1),
        Color.fromRGBO(250, 97, 215, 1),
        Color.fromRGBO(253, 127, 176, 1)
      ]);

  // for inactive gradiant
  static LinearGradient IAgradiant =
      const LinearGradient(colors: [Colors.white, Colors.white]);

  // text color dark theme
  static Function textColorDark =
      (opacity) => Color.fromRGBO(239, 241, 255, opacity);

  // text color light theme
  static Function textColorLight =
      (opacity) => Color.fromRGBO(66, 67, 103, opacity);

  // backgroung gradient dark theme
  static LinearGradient backgroundDark = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(63, 64, 100, 1),
      Color.fromRGBO(34, 34, 61, 1),
    ],
  );

  // background gradient light theme
  static LinearGradient backgroundLight = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Color.fromRGBO(239, 239, 255, 1),
    ],
  );

  // bottom icon inactive color dark theme
  static Color navbarIconIADark = const Color.fromRGBO(64, 65, 101, 1);

  // bottom icon inactive color light theme
  static Color navbarIconIALight = const Color.fromRGBO(189, 189, 209, 1);
}
