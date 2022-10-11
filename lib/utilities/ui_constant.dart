import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Created by Yunus Emre Yıldırım
/// on 8.09.2022

class UIConstant {
  static ThemeData get defaultThemeLight {
    return ThemeData(
      // primarySwatch: const MaterialColor(0XFF333340, <int, Color>{
      //   50: Color.fromRGBO(128, 222, 234, 1),
      //   100: Color.fromRGBO(121, 134, 203, 1),
      //   200: Color.fromRGBO(76, 175, 80, 1),
      //   300: Color.fromRGBO(30, 136, 229, 1),
      //   400: Color.fromRGBO(194, 24, 91, 1),
      //   500: Color.fromRGBO(239, 83, 80, 1),
      //   600: Color.fromRGBO(255, 87, 34, 1),
      //   700: Color.fromRGBO(93, 64, 55, 1),
      //   800: Color.fromRGBO(96, 125, 139, 1),
      //   900: Color.fromRGBO(66, 66, 66, 1),
      // }),
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      secondaryHeaderColor: Colors.deepOrangeAccent,
      backgroundColor: Colors.white70,
      hintColor: Colors.black,
      textTheme: GoogleFonts.ubuntuCondensedTextTheme(),
    );
  }


  static ThemeData get defaultThemeDark {
    return ThemeData(
      // primarySwatch: const MaterialColor(0XFF333340, <int, Color>{
      //   50: Color.fromRGBO(128, 222, 234, 1),
      //   100: Color.fromRGBO(121, 134, 203, 1),
      //   200: Color.fromRGBO(76, 175, 80, 1),
      //   300: Color.fromRGBO(30, 136, 229, 1),
      //   400: Color.fromRGBO(194, 24, 91, 1),
      //   500: Color.fromRGBO(239, 83, 80, 1),
      //   600: Color.fromRGBO(255, 87, 34, 1),
      //   700: Color.fromRGBO(93, 64, 55, 1),
      //   800: Color.fromRGBO(96, 125, 139, 1),
      //   900: Color.fromRGBO(66, 66, 66, 1),
      // }),
      brightness: Brightness.dark,
      primaryColor: Colors.deepOrangeAccent,
      secondaryHeaderColor: Colors.blue,
      backgroundColor: Colors.black38,
      hintColor: Colors.white,
      textTheme: GoogleFonts.ubuntuCondensedTextTheme(),
    );
  }
}

