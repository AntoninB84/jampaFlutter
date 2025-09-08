import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/ui/widgets/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

class NoteTitleTextField extends StatefulWidget {
  const NoteTitleTextField({super.key,
    this.value,
    this.isValid = true,
    required this.validator,
    required this.onChanged,
  });

  final String? value;
  final bool isValid;
  final NameValidator validator;
  final Function(String) onChanged;

  @override
  State<NoteTitleTextField> createState() => _NoteTitleTextFieldState();
}

class _NoteTitleTextFieldState extends State<NoteTitleTextField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.value != null){
      _textEditingController.text = widget.value!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      hintText: context.strings.create_note_title_field_hint,
      errorWidget: !widget.isValid ? ErrorText(
          errorText: (){
            if ((widget.validator.displayError?.isEmpty ?? false) || (widget.validator.displayError?.isInvalidLength ?? false)) {
              return context.strings.create_note_title_invalid_length;
            }
            return context.strings.generic_error_message;
          }()
      ) : null
    );
  }
}