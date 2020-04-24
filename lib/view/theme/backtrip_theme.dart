import 'package:flutter/material.dart';

//    primaryColor: Color.fromRGBO(119, 133, 165, 1),
//    primaryColorLight: Color.fromRGBO(162, 157, 183, 1),
//    accentColor: Color.fromRGBO(170, 216, 221, 1),
//    buttonColor: Color.fromRGBO(119, 133, 165, 1),

class BacktripTheme {
  ThemeData get theme => ThemeData(
      brightness: Brightness.light,
      accentColorBrightness: Brightness.light,
      primaryColor: Color.fromRGBO(102, 115, 138, 1),
      primaryColorLight: Color.fromRGBO(157, 172, 189, 1),
      primaryColorDark: Color.fromRGBO(82, 92, 116, 1),
      accentColor: Color.fromRGBO(139, 186, 187, 1),
      buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(102, 115, 138, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0))),
      textTheme:
          TextTheme(button: TextStyle(fontSize: 17, color: Colors.white)));
}

extension ExtendedColorScheme on ColorScheme {
  Color get success => const Color.fromRGBO(125, 204, 106, 1);

  Color get primaryColorVeryLight => const Color.fromRGBO(174, 189, 202, 1);

  Color get accentColorLight => const Color.fromRGBO(199, 240, 219, 1);
  Color get accentColorDark => const Color.fromRGBO(125, 169, 169, 1);

  Color get textFieldFillColor => const Color(0xfff3f3f4);
}
