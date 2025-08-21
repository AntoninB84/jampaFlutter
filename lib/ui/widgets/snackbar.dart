import 'package:flutter/material.dart';

class SnackBarX {

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

  static void showError(BuildContext context, String message) {
    _snackbar(context, message: message, color: Colors.red);
  }
  static void showSuccess(BuildContext context, String message) {
    _snackbar(context, message: message, color: Colors.green);
  }
}