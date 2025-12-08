import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/forms/email_validator.dart';

import '../../../../utils/extensions/app_context_extension.dart';
import '../../../widgets/error_text.dart';
import '../../../widgets/inputs/custom_text_field.dart';

class EmailField extends StatefulWidget {
  const EmailField({super.key,
    this.value,
    required this.validator,
    required this.onChanged,
  });

  final String? value;
  final EmailValidator validator;
  final Function(String) onChanged;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.value != null){
      _textEditingController.text = widget.value!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EmailField oldWidget) {
    if(oldWidget.value != widget.value){
      _textEditingController.text = widget.value ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
        keyboardType: TextInputType.emailAddress,
        controller: _textEditingController,
        onChanged: widget.onChanged,
        hintText: context.strings.login_email_field_hint,
        errorWidget: (!widget.validator.isPure && widget.validator.isNotValid)
            ? ErrorText(errorText: (){
          if (widget.validator.displayError?.isEmpty ?? false){
            return context.strings.login_email_empty_error;
          }
          if (widget.validator.displayError?.isInvalidFormat ?? false) {
            return context.strings.login_email_invalid_format_error;
          }
          return context.strings.generic_error_message;
        }()
        ) : null
    );
  }
}