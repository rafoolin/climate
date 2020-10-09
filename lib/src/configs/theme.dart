import 'package:flutter/material.dart';

// ================================================================================
// =                                  DARK THEME                                  =
// ================================================================================
final ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: _darkTextTheme,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    brightness: Brightness.dark,
  ),
  accentColor: Colors.white54,
  buttonColor: Colors.red,
  iconTheme: IconThemeData(color: Color(0xfff5f5f5)),
  unselectedWidgetColor: Color(0xfff5f5f5),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xff1b1b1b),
    actionTextColor: Color(0xff7c9ed9),
    contentTextStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: Colors.white,
      fontWeight: FontWeight.w300,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: Colors.white38,
        style: BorderStyle.solid,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: Colors.white38,
        style: BorderStyle.solid,
      ),
    ),
    labelStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: Colors.white54,
      fontSize: 16.0,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w700,
    ),
    hintStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: Colors.white38,
      fontSize: 16.0,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w500,
    ),
  ),
);

// --------------------------------- Dark TextTheme ---------------------------------
TextTheme _darkTextTheme = TextTheme(
  headline1: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 95,
    fontWeight: FontWeight.w300,
    color: Colors.red,
    letterSpacing: -1.5,
  ),
  headline2: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 59,
    fontWeight: FontWeight.w300,
    color: Colors.blue,
    letterSpacing: -0.5,
  ),
  headline3: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: Colors.green,
  ),
  headline4: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    letterSpacing: 0.25,
  ),
  headline5: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.white70,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  headline6: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.white70,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  subtitle1: TextStyle(
    fontFamily: 'NotoSans',
    color: Color(0xfff5f5f5),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  ),
  subtitle2: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.white70,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  ),
  bodyText1: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 16,
    color: Colors.white70,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
  bodyText2: TextStyle(
    fontFamily: 'NotoSans',
    color: Color(0xfff5f5f5),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
  ),
  button: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  caption: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.white38,
    fontSize: 12,
    fontWeight: FontWeight.w100,
    letterSpacing: 0.4,
  ),
  overline: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.yellowAccent,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);

// ================================================================================
// =                                 LIGHT THEME                                  =
// ================================================================================
final ThemeData lightTheme = ThemeData.light().copyWith(
  textTheme: _lightTextTheme,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  unselectedWidgetColor: Color(0xff464646),
  iconTheme: IconThemeData(
    color: Color(0xff464646),
  ),
  accentColor: Colors.black38,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xff343534),
    actionTextColor: Color(0xff7c9ed9),
    contentTextStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: Colors.white,
      fontWeight: FontWeight.w300,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: Colors.black38,
        style: BorderStyle.solid,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: Colors.black38,
        style: BorderStyle.solid,
      ),
    ),
    labelStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: Colors.black54,
      fontSize: 16.0,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w700,
    ),
    hintStyle: TextStyle(
      fontFamily: 'NotoSans',
      color: Colors.black38,
      fontSize: 16.0,
      letterSpacing: 0.25,
      fontWeight: FontWeight.w500,
    ),
  ),
);

// -------------------------------- Light TextTheme ---------------------------------
TextTheme _lightTextTheme = TextTheme(
  headline1: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 95,
    fontWeight: FontWeight.w300,
    color: Colors.red,
    letterSpacing: -1.5,
  ),
  headline2: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 59,
    fontWeight: FontWeight.w300,
    color: Colors.blue,
    letterSpacing: -0.5,
  ),
  headline3: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: Colors.green,
  ),
  headline4: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
    letterSpacing: 0.25,
  ),
  headline5: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.black54,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  ),
  headline6: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.black54,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  subtitle1: TextStyle(
    fontFamily: 'NotoSans',
    color: Color(0xff464646),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  ),
  subtitle2: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.black54,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  ),
  bodyText1: TextStyle(
    fontFamily: 'NotoSans',
    fontSize: 16,
    color: Colors.black54,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
  bodyText2: TextStyle(
    fontFamily: 'NotoSans',
    color: Color(0xff464646),
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
  ),
  button: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  caption: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.black38,
    fontSize: 12,
    fontWeight: FontWeight.w100,
    letterSpacing: 0.4,
  ),
  overline: TextStyle(
    fontFamily: 'NotoSans',
    color: Colors.yellowAccent,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);
