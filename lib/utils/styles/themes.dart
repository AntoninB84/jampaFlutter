import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/styles/colors.dart';

// Dark theme
ThemeData get darkTheme {
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(JampaColors.seedColor),
      brightness: Brightness.dark,
    ),
    visualDensity: VisualDensity.compact,
    useMaterial3: true,
  );
}

// Light theme
ThemeData get lightTheme {
  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(JampaColors.seedColor),
      brightness: Brightness.light,
    ),
    visualDensity: VisualDensity.compact,
    useMaterial3: true,
  );
}