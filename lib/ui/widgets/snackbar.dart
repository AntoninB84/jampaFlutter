import 'package:flutter/material.dart';

/// A utility class for displaying snack bars with different styles.
class SnackBarX {

  /// The base widget for displaying snack bars.
  static void _snackbar(BuildContext context, {
     required String message,
     required Color color
   }) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  /// Displays an error snack bar with a predefined error color.
  static void showError(BuildContext context, String message) {
    _snackbar(context, message: message, color: Theme.of(context).colorScheme.errorContainer);
  }

  /// Displays a success snack bar with a predefined success color.
  static void showSuccess(BuildContext context, String message) {
    _snackbar(context, message: message, color: Theme.of(context).colorScheme.primary);
  }
}