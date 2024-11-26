import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColorDark = Color(0xFF004265);
const primaryColorMedium = Color(0xff005B8A);
const primaryColorLight = Color(0xff008cd7);

const primaryColorTrafficBlue = Color(0xff005c8e);
const primaryColorSolarGray = Color(0xff3c4553);
const primaryColorLightGray = Color(0xffc0cac7);
const primaryColorSignalWhite = Color(0xfff4f4f4);
const primaryColorSignalBlack = Color(0xff2a2a2c);
const primaryColorPureGreen = Color(0xff309040);
const primaryColorPureRed = Color(0xffd7292e);
const primaryColorPureYellow = Color(0xfffbca2f);

const textColorWhite = Colors.white;
const textColorBlack = Colors.black;
const textColorGray = Colors.grey;

final ThemeData myTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColorDark: primaryColorDark,
  primaryColor: primaryColorMedium,
  primaryColorLight: primaryColorLight,
  scaffoldBackgroundColor: primaryColorSignalWhite,
  hoverColor: primaryColorLight,


  fontFamily: GoogleFonts.roboto().fontFamily,
  /*navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: primaryColorDark,
    elevation: 5,
    labelType: NavigationRailLabelType.all,
    indicatorColor: primaryColorLight,
    unselectedLabelTextStyle: TextStyle(color: Colors.white),
    selectedLabelTextStyle: TextStyle(color: Colors.white),
    unselectedIconTheme: IconThemeData(color: Colors.white),
  ),*/
  navigationRailTheme: const NavigationRailThemeData(
    backgroundColor: primaryColorDark,
    elevation: 0,
    labelType: NavigationRailLabelType.all,
    indicatorColor: primaryColorLight,
    selectedLabelTextStyle: TextStyle(color: Colors.white),
    unselectedLabelTextStyle: TextStyle(color: Colors.white),
    unselectedIconTheme: IconThemeData(color: Colors.white),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColorDark,
    titleTextStyle: TextStyle(color: textColorWhite, fontSize: 22),
    iconTheme: IconThemeData(
      color: Colors.white, // Set your desired color here
    ),
  ),


  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 22, color: textColorBlack),
    titleMedium: TextStyle(fontSize: 15, color: textColorBlack),
    titleSmall: TextStyle(fontSize: 12, color: textColorBlack),
    bodyMedium : TextStyle(fontSize: 13, color: textColorBlack, fontWeight: FontWeight.bold),
    bodySmall : TextStyle(fontSize: 12, color: textColorBlack, fontWeight: FontWeight.bold),
  ),

  colorScheme: ColorScheme.fromSeed(
    primary: primaryColorMedium,
    secondary: primaryColorPureYellow,
    seedColor: primaryColorMedium,
  ),
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //       foregroundColor: textColorWhite, backgroundColor: primaryColorDark
  //   ),
  // ),
);
