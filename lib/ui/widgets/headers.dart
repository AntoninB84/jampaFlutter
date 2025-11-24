import 'package:flutter/material.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';

class Headers {

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