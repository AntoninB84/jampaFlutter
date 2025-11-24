import 'package:flutter/material.dart';

/// A widget that displays error text in a styled manner.
class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.errorText});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}