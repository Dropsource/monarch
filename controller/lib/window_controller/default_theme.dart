import 'package:flutter/material.dart';
import 'package:monarch_annotations/monarch_annotations.dart';

// const Color offWhite = Color(0xFFF8F9FA);
const Color black = Color(0xFF071232);
const Color blue = Color(0xFF2D407F);
const Color lightBlue = Color(0xFF9EA4B6);
const Color green = Color(0xFF01B9AD);
const Color lightGreen = Color(0xFFD5F7F0);
const Color grey = Color(0xFF737B88);
const Color lightGrey = Color(0xFFF3F3F3);
const Color secondaryLightGrey = Color(0xFFEEEFF2);
const Color secondaryGrey = Color(0xFF9CA0AD);
const Color red = Color(0xFFDF7272);
const Color dark = Color(0xFF1C1E22);
const Color darkGrey = Color(0xFF2E3137);

const Color fontPrimaryColor = Colors.white;
const Color fontSecondaryColor = Color(0xFFF3F3F3);

const Color primaryButtonBackground = Color(0xFF2a2d52);

const Color inputHintColor = secondaryGrey; //Color(0xFFCBD0D5);
const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8.0));

const BoxDecoration shadowDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: Colors.white,
  border: Border.fromBorderSide(BorderSide(color: secondaryLightGrey)),
  boxShadow: [
    BoxShadow(
      color: secondaryLightGrey,
      blurRadius: 1,
      offset: Offset(0, 0.5), // changes position of shadow
    ),
  ],
);

const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: 20);

const boldStyle = TextStyle(fontWeight: FontWeight.bold);
final boldHeaderStyle = boldStyle.copyWith(fontSize: 18, color: blue);

const InputBorder inputBorder = OutlineInputBorder(
  borderRadius: borderRadius,
  borderSide: BorderSide(color: lightGrey),
);

const EdgeInsets listPadding =
    EdgeInsets.symmetric(horizontal: 20, vertical: 10);

@MonarchTheme('Default Theme', isDefault: true)
final ThemeData theme = ThemeData.dark().copyWith(
  primaryColor: blue,
  splashColor: Colors.transparent,
  errorColor: red,
  scaffoldBackgroundColor: dark,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 30.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline2: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 28.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline3: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 26.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline4: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 24.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    headline5: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 13.0,
      color: fontPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    headline6: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    bodyText1: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 11,
    ),
    bodyText2: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 9,
    ),
    subtitle1: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
    subtitle2: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    caption: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 9,
    ),
    overline: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      letterSpacing: 1.1,
    ),
    button: TextStyle(
      fontFamily: 'Roboto',
      color: fontPrimaryColor,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    labelStyle: TextStyle(
      color: inputHintColor,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    ),
    hintStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 11,
      color: inputHintColor,
    ),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: lightGrey), borderRadius: borderRadius),
    enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius, borderSide: BorderSide(color: lightGrey)),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: lightGrey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: red),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    height: 50.0,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
    splashColor: Colors.transparent,
  ),
  //bottomAppBarColor: Colors.white,
  appBarTheme: const AppBarTheme(
    elevation: 1.5,
    iconTheme: IconThemeData(color: blue),
  ),
  backgroundColor: dark,
);
