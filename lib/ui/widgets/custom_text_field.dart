import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.onChanged,
    this.errorWidget,
    required this.hintText,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController? controller;
  final Function(String value) onChanged;
  final Widget? errorWidget;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        error: errorWidget,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
    );
  }
}