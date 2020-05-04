import 'package:flutter/material.dart';

class BacktripTheme {
  ThemeData get theme => ThemeData(
      brightness: Brightness.light,
      accentColorBrightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFF8bbabb, const <int, Color>{
        50: const Color(0xFFB2DDDD),
        100: const Color(0xFFAAD6D6),
        200: const Color(0xFFA2CFCF),
        300: const Color(0xFF9AC8C9),
        400: const Color(0xFF93C1C2),
        500: const Color(0xFF8bbabb),
        600: const Color(0xFF7DA9A9),
        700: const Color(0xFF6f9798),
        800: const Color(0xFF618686),
        900: const Color(0xFF537475),
      }),
      primaryColorBrightness: Brightness.dark,
      primaryColor: Color(0xFF8bbabb),
      primaryColorLight: Color(0xFFE5F1F1),
      primaryColorDark: Color(0xFF7DA9A9),
      accentColor: Color(0xFF6C7584),
      cursorColor: Color(0xFF6C7584),
      textSelectionColor: Color(0xFFB6BDC3),
      textSelectionHandleColor: Color(0xFF7DA9A9),
      buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF6C7584),
          textTheme: ButtonTextTheme.normal,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xFF8bbabb)),
      textTheme:
          TextTheme(button: TextStyle(fontSize: 17, color: Colors.white)));
}

extension ExtendedColorScheme on ColorScheme {
  Color get success => const Color(0xFF7DCC6A);

  Color get accentColorLight => Color(0xFF939ca7);

  Color get accentColorVeryLight => Color(0xFFB6BDC3);

  Color get accentColorDark => Color(0xFF5A5F6D);

  Color get textFieldFillColor => Color(0xfff3f3f4);
}
