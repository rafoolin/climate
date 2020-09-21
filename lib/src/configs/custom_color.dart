import 'package:flutter/material.dart';

class CustomColor {
  static const Color yellow = Color(0xffF3BF37);
  static const Color orange = Color(0xffF58134);
  static const Color green = Color(0xff239281);
  static const Color grey = Color(0xffD0D2D3);
  static const Color defaultColor = Color(0xffd9adad);

  static Color weatherStateColor({@required String weatherStateAbbr}) {
    switch (weatherStateAbbr?.toLowerCase()?.trim()) {
      case 'sn':
      case 'sl':
      case 'h':
        return grey;
        break;
      case 't':
      case 'hr':
      case 'lr':
      case 'hc':
        return green;
        break;

      case 's':
      case 'lc':
      case 'c':
        return orange;
        break;
      default:
        return defaultColor;
    }
  }
}
