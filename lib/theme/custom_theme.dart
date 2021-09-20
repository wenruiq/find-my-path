import "package:flutter/material.dart";

MaterialColor _chosenMaterialColor = const MaterialColor(
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

ThemeData customTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: _chosenMaterialColor,
  ),
).copyWith(
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
);
