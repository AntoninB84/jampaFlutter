import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/constants/styles/sizes.dart';

/// A collection of commonly used button widgets.
///
/// This abstract class provides static methods to create various types of
/// icon buttons such as delete, edit, back, add, and save buttons. Each method
/// allows customization of the button's behavior and density through parameters.
abstract class Buttons {

  static Widget defaultButton({
    required Function()? onPressed,
    required String text,
    bool enabled = true,
    bool isLoading = false,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      child: isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ) :  Text(text),
    );
  }

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

  static Widget saveButtonIcon({
    required BuildContext context,
    required Function()? onPressed,
    VisualDensity visualDensity = VisualDensity.compact,
  }) {
    return IconButton(
      icon: Icon(
        Icons.save,
        color: onPressed != null
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      visualDensity: visualDensity,
      onPressed: onPressed,
    );
  }
}