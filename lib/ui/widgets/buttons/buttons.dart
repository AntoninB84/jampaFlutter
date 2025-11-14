import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';

abstract class Buttons {

  static Widget deleteButtonIcon({
    required BuildContext context,
    required Function()? onPressed,
    VisualDensity visualDensity = VisualDensity.compact,
  }) {
    return IconButton(
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
        ),
        visualDensity: visualDensity,
        onPressed: onPressed,
    );
  }

  static Widget editButtonIcon({
    required BuildContext context,
    required Function()? onPressed,
    VisualDensity visualDensity = VisualDensity.compact,
  }) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).colorScheme.primary,
      ),
      visualDensity: visualDensity,
      onPressed: onPressed,
    );
  }
  
  static Widget backButtonIcon({
    required BuildContext context,
    required Function()? onPressed,
    VisualDensity visualDensity = VisualDensity.compact,
  }) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      visualDensity: visualDensity,
      onPressed: onPressed,
    );
  }

  static Widget addButtonIcon({
    required BuildContext context,
    required Function()? onPressed,
    VisualDensity visualDensity = VisualDensity.compact,
    double iconSize = kHeadingLSize,
  }) {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.primary,
      ),
      visualDensity: visualDensity,
      onPressed: onPressed,
    );
  }
}