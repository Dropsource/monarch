import 'package:flutter/material.dart';
import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:monarch_window_controller/window_controller/widgets/stockholm/theme.dart';

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
const Color darkGrey = Color(0xFF27282B);

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
