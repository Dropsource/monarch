import 'package:flutter/material.dart';
import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:stockholm/stockholm.dart';

const Color red = Color(0xFFDF7272);
const Color dark = Color(0xFF1C1E22);
const Color darkGrey = Color(0xFF27282B);

const Color fontPrimaryColor = Colors.white;
const Color fontSecondaryColor = Color(0xFFF3F3F3);
const Color primaryButtonBackground = Color(0xFF2a2d52);
const Color blue = Color(0xFF2D407F);

@MonarchTheme('Default Theme', isDefault: true)
 ThemeData get theme => StockholmThemeData.dark().copyWith(
  primaryColor: blue,
  splashColor: Colors.transparent,
  visualDensity: VisualDensity.compact,
  errorColor: red,
  scaffoldBackgroundColor: dark,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 30.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline2: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 28.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline3: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 26.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline4: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 24.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline5: TextStyle(
      fontFamily: 'San Francisco',
      fontSize: 13.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    headline6: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    bodyText1: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    ),
    bodyText2: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 10,
    ),
    subtitle1: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
    subtitle2: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    caption: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 9,
    ),
    overline: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      letterSpacing: 1.1,
    ),
    button: TextStyle(
      fontFamily: 'San Francisco',
      color: fontPrimaryColor,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    ),
  ),
  backgroundColor: dark,
);
