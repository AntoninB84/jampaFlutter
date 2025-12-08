import 'package:flutter/material.dart';

import '../../../utils/constants/styles/sizes.dart';

/// A customizable text field widget with optional error display.
/// [CustomTextField] allows you to specify a controller, onChanged callback,
/// error widget, hint text, and keyboard type.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.onChanged,
    this.errorWidget,
    required this.hintText,
    this.keyboardType = .text,
    this.inputDecoration,
    this.passwordVisible
  });

  final TextEditingController? controller;
  final Function(String value) onChanged;

  final Widget? errorWidget;
  final String hintText;

  final TextInputType keyboardType;

  final InputDecoration? inputDecoration;

  final bool? passwordVisible;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: inputDecoration?.copyWith(error: errorWidget) ?? InputDecoration(
        hintText: hintText,
        error: errorWidget,
        border: OutlineInputBorder(
          borderRadius: kRadius12
        ),
      ),
      obscureText: passwordVisible != null ? !passwordVisible! : false,
    );
  }
}