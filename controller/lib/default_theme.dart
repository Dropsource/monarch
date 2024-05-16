import 'package:flutter/material.dart';
import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:stockholm/stockholm.dart';

const Color red = Color(0xFFDF7272);
const Color dark = Color(0xFF1C1E22);
const Color darkGrey = Color(0xFF27282B);
const Color sliderTrackColor = Color(0xFF3F4042);
const Color sliderThumbColor = Color(0xFFDADADA);
const Color sliderDividerColor = sliderTrackColor;

const Color fontPrimaryColor = Colors.white;
const Color fontSecondaryColor = Color(0xFFF3F3F3);
const Color primaryButtonBackground = Color(0xFF2a2d52);
const Color blue = Color(0xFF2D407F);
const Color searchHighlightColor = Colors.amber;

@MonarchTheme('Default Theme')
ThemeData get theme => StockholmThemeData.dark().copyWith(
      primaryColor: blue,
      splashColor: Colors.transparent,
      visualDensity: VisualDensity.compact,
      colorScheme: StockholmThemeData.dark().colorScheme.copyWith(
            error: red,
            surface: dark,
          ),
      scaffoldBackgroundColor: dark,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'San Francisco',
          fontSize: 30.0,
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        displayMedium: TextStyle(
          fontFamily: 'San Francisco',
          fontSize: 28.0,
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        displaySmall: TextStyle(
          fontFamily: 'San Francisco',
          fontSize: 26.0,
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'San Francisco',
          fontSize: 24.0,
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'San Francisco',
          fontSize: 13.0,
          color: fontPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        titleMedium: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        titleSmall: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 9,
        ),
        labelSmall: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 11,
          letterSpacing: 1.1,
        ),
        labelLarge: TextStyle(
          fontFamily: 'San Francisco',
          color: fontPrimaryColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
