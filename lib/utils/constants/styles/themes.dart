import "package:flutter/material.dart";
import "package:jampa_flutter/utils/constants/styles/sizes.dart";
import "package:jampa_flutter/utils/constants/styles/styles.dart";
import "colors.dart";

class MaterialTheme {
  static ThemeData get lightTheme {
    return theme(JampaColors.lightScheme);
  }

  static ThemeData get lightMediumContrast {
    return theme(JampaColors.lightMediumContrastScheme);
  }

  static ThemeData get lightHighContrast {
    return theme(JampaColors.lightHighContrastScheme);
  }

  static ThemeData get darkTheme {
    return theme(JampaColors.darkScheme);
  }

  static ThemeData get darkMediumContrast {
    return theme(JampaColors.darkMediumContrastScheme);
  }

  static ThemeData get darkHighContrast {
    return theme(JampaColors.darkHighContrastScheme);
  }

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: kRadius12,
      ),
      tileColor: colorScheme.surfaceContainer,
    )
  );

  List<ExtendedColor> get extendedColors => [
  ];

}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}