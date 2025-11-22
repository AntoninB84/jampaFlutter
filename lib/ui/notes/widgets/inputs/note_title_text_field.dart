import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/ui/widgets/inputs/custom_text_field.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

class NoteTitleTextField extends StatefulWidget {
  const NoteTitleTextField({super.key,
    this.value,
    required this.validator,
    required this.onChanged,
  });

  final String? value;
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
  void didUpdateWidget(covariant NoteTitleTextField oldWidget) {
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
      controller: _textEditingController,
      onChanged: widget.onChanged,
      hintText: context.strings.create_note_title_field_hint,
      errorWidget: (!widget.validator.isPure && widget.validator.isNotValid)
          ? ErrorText(errorText: (){
            if ((widget.validator.displayError?.isEmpty ?? false) || (widget.validator.displayError?.isInvalidLength ?? false)) {
              return context.strings.create_note_title_invalid_length;
            }
            return context.strings.generic_error_message;
          }()
      ) : null
    );
  }
}