import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/forms/password_validator.dart';

import '../../../../utils/constants/styles/sizes.dart';
import '../../../../utils/extensions/app_context_extension.dart';
import '../../../widgets/error_text.dart';
import '../../../widgets/inputs/custom_text_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key,
    this.value,
    required this.hintText,
    required this.isPasswordVisible,
    this.passwordsMatch,
    required this.validator,
    required this.onChanged,
    required this.onTogglePasswordVisibility,
  });

  final String? value;
  final String hintText;
  final bool isPasswordVisible;
  final bool? passwordsMatch;
  final PasswordValidator validator;
  final Function(String) onChanged;
  final Function() onTogglePasswordVisibility;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.value != null){
      _textEditingController.text = widget.value!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.value != widget.value && _textEditingController.text != widget.value){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textEditingController.text = widget.value ?? '';
        }
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      inputDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: kRadius12
        ),
        suffixIcon: IconButton(
          icon: Icon(
            widget.isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: widget.onTogglePasswordVisibility
        ),
        hintText: widget.hintText,
      ),
      hintText: widget.hintText,
      keyboardType: TextInputType.emailAddress,
      controller: _textEditingController,
      onChanged: widget.onChanged,
      passwordVisible: widget.isPasswordVisible,
      errorWidget: ((!widget.validator.isPure && widget.validator.isNotValid)
          || (widget.passwordsMatch != null && !widget.passwordsMatch!))
          ? ErrorText(errorText: (){
        if (widget.passwordsMatch != null && !widget.passwordsMatch!) {
          return context.strings.passwords_do_not_match_error;
        }
        if (widget.validator.displayError?.isEmpty ?? false){
          return context.strings.password_empty_error;
        }
        if (widget.validator.displayError?.isTooShort ?? false) {
          return context.strings.password_too_short_error;
        }
        if (widget.validator.displayError?.hasNoUppercase ?? false) {
          return context.strings.password_no_uppercase_error;
        }
        if (widget.validator.displayError?.hasNoLowercase ?? false) {
          return context.strings.password_no_lowercase_error;
        }
        if (widget.validator.displayError?.hasNoNumber ?? false) {
          return context.strings.password_no_number_error;
        }
        if (widget.validator.displayError?.hasNoSpecialCharacter ?? false) {
          return context.strings.password_no_special_char_error;
        }
        return context.strings.generic_error_message;
      }()
      ) : null
    );
  }
}