import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
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

MenuThemeData menuThemeData(ColorScheme colorScheme) {
  return MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStateProperty.all(colorScheme.surfaceBright),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: kRadius8,
        ),
      ),
    ),
  );
}

PopupMenuThemeData popupMenuThemeData(ColorScheme colorScheme) {
  return PopupMenuThemeData(
    color: colorScheme.surfaceBright,
    shape: RoundedRectangleBorder(
      borderRadius: kRadius8,
    ),
  );
}

DropdownMenuThemeData dropdownMenuThemeData(ColorScheme colorScheme) {
  return DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(colorScheme.surfaceBright),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: kRadius8,
        ),
      ),
    ),
  );
}

class MultiDropdownTheme {
  static FieldDecoration fieldDecoration(BuildContext context, String? labelText) {
    return FieldDecoration(
      labelText: labelText,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
      hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
      border: OutlineInputBorder(
        borderRadius: kRadius8,
        borderSide: BorderSide(
          color: Theme.of(context).inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey,
        )
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kRadius8,
        borderSide: BorderSide(
          color: Theme.of(context).inputDecorationTheme.focusedBorder?.borderSide.color ?? Colors.grey,
        )
      ),
    );
  }

  static DropdownDecoration dropdownDecoration(BuildContext context) {
    return DropdownDecoration(
      backgroundColor: Theme.of(context).popupMenuTheme.color ?? Colors.red,
    );
  }

  static DropdownItemDecoration dropdownItemDecoration(BuildContext context) {
    return DropdownItemDecoration(
      selectedBackgroundColor: Colors.transparent
    );
  }

  static ChipDecoration chipDecoration(BuildContext context) {
    return ChipDecoration(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}


