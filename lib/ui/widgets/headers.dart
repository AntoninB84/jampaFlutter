import 'package:flutter/material.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';

/// A class containing static methods for creating header widgets.
class Headers {

  /// Creates a list header with a title and an add button.
  static Widget listHeader({
    required BuildContext context,
    required String title,
    required VoidCallback onAddPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        Buttons.addButtonIcon(
          context: context,
          onPressed: onAddPressed,
          visualDensity: VisualDensity.standard,
        ),
      ],
    );
  }

  /// Creates a basic header with just a title.
  static Widget basicHeader({
    required BuildContext context,
    required String title
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }
}