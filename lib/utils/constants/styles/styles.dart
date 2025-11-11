import 'dart:ui';

import 'package:flutter/material.dart';
import 'sizes.dart';

TextTheme get textTheme {
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kDisplayLSize,
    ),
    displayMedium: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kDisplayMSize,
    ),
    displaySmall: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kDisplaySSize,
    ),
    headlineLarge: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kHeadingLSize,
    ),
    headlineMedium: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kHeadingMSize,
    ),
    headlineSmall: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kHeadingSSize,
    ),
    titleLarge: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kTitleLSize,
    ),
    titleMedium: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kTitleMSize,
    ),
    titleSmall: TextStyle(
      fontFamily: "UbuntuMono",
      fontSize: kTitleSSize,
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
    ),
  );
}

const TextStyle kHeading1 = TextStyle(
  fontSize: kHeadingLSize,
  fontWeight: FontWeight.bold,
);

const TextStyle kHeading2 = TextStyle(
  fontSize: kHeadingMSize,
  fontWeight: FontWeight.bold,
);

const TextStyle kBodyText = TextStyle(
  fontSize: kBodyLSize,
);

