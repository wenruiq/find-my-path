import "package:flutter/material.dart";

MaterialColor _customMaterialColor = const MaterialColor(
  0xFF1d4289,
  {
    50: Color(0xFF1D5D89),
    100: Color(0xFF1d5489),
    200: Color(0xFF1d4b89),
    300: Color(0xFF1d4289),
    400: Color(0xFF1d4289),
    500: Color(0xFF1d4289),
    600: Color(0xFF1d4289),
    700: Color(0xFF1d3989),
    800: Color(0xFF1d3089),
    900: Color(0xFF1D2789),
  },
);

TextTheme _customTextTheme = const TextTheme(
    // headline1: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // headline2: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // headline3: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // headline4: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // headline5: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // headline6: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // bodyText1: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // bodyText2: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // subtitle1: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // subtitle2: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // button: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // caption: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    // overline: TextStyle(
    //   fontSize: 20,
    //   fontWeight: FontWeight.normal,
    // ),
    );

ThemeData customTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: _customMaterialColor,
  ),
  // textTheme: _customTextTheme,
).copyWith(
  scaffoldBackgroundColor: const Color(0xFFfafafa),
);
