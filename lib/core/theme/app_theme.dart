import 'package:chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData.light().copyWith(
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: appBarTheme,
  iconTheme: const IconThemeData(color: kContentColorLightTheme),
  textTheme:
      GoogleFonts.interTextTheme().apply(bodyColor: kContentColorLightTheme),
  colorScheme: const ColorScheme.light(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    error: kErrorColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
    unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
    selectedIconTheme: const IconThemeData(color: kPrimaryColor),
    showUnselectedLabels: true,
  ),
);

const appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
