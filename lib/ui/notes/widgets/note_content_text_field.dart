import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/ui/widgets/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/content_validator.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';

class NoteContentTextField extends StatefulWidget {
  const NoteContentTextField({super.key,
    this.value,
    this.isValid = true,
    required this.validator,
    required this.onChanged,
  });

  final String? value;
  final bool isValid;
  final ContentValidator validator;
  final Function(String) onChanged;

  @override
  State<NoteContentTextField> createState() => _NoteContentTextFieldState();
}

class _NoteContentTextFieldState extends State<NoteContentTextField> {

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
        hintText: context.strings.create_note_content_field_hint,
        errorWidget: !widget.isValid ? ErrorText(
            errorText: (){
              if (widget.validator.displayError?.isEmpty ?? false) {
                return context.strings.create_note_content_invalid_length;
              }
              return context.strings.generic_error_message;
            }()
        ) : null
    );
  }
}