import 'package:flutter/material.dart';

class FontSizeUtils {
  static double? fontSizeHeading(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = (screenWidth / 100) + 5;
    // return fontSize ?? 15 ;
    fontSize <= 7
        ? 9
        : fontSize > 15
        ? 15
        : fontSize;
     return 13;
  }

  static double? fontSizeLabel(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = (screenWidth / 100) + 3;
    // return fontSize ?? 11.5;
    fontSize <= 5
        ? 7
        : fontSize > 14
        ? 14
        : fontSize;
     return 12;
  }
}
