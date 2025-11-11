import 'dart:ui';

import 'package:flutter/material.dart';
import 'sizes.dart';

TextTheme get textTheme {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kDisplayLSize,
      fontWeight: FontWeight.bold
    ),
    displayMedium: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kDisplayMSize,
      fontWeight: FontWeight.bold
    ),
    displaySmall: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kDisplaySSize,
      fontWeight: FontWeight.bold
    ),
    headlineLarge: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kHeadingLSize,
      fontWeight: FontWeight.w600
    ),
    headlineMedium: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kHeadingMSize,
        fontWeight: FontWeight.w600
    ),
    headlineSmall: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kHeadingSSize,
        fontWeight: FontWeight.w600
    ),
    titleLarge: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kTitleLSize,
        fontWeight: FontWeight.w600
    ),
    titleMedium: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kTitleMSize,
        fontWeight: FontWeight.w600
    ),
    titleSmall: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kTitleSSize,
        fontWeight: FontWeight.w600
    ),
    bodyLarge: TextStyle(
      fontFamily: "Ubuntu",
      fontSize: kBodyLSize,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Ubuntu",
      fontSize: kBodyMSize,
    ),
    bodySmall: TextStyle(
      fontFamily: "Ubuntu",
      fontSize: kBodySSize,
        fontWeight: FontWeight.w300
    ),
    labelLarge: TextStyle(
      fontFamily: "Ubuntu",
      fontSize: kLabelLSize,
    ),
    labelMedium: TextStyle(
      fontFamily: "Ubuntu",
      fontSize: kLabelMSize,
    ),
    labelSmall: TextStyle(
      fontFamily: "Ubuntu",
      fontSize: kLabelSSize,
        fontWeight: FontWeight.w300
    ),
  );
}

