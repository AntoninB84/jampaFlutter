import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/ui/widgets/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';

class AlarmOffsetTextField extends StatefulWidget {
  const AlarmOffsetTextField({super.key,
    this.value,
    this.isValid = true,
    required this.validator,
    required this.onChanged,
  });

  final String? value;
  final bool isValid;
  final PositiveValueValidator validator;
  final Function(String) onChanged;

  @override
  State<AlarmOffsetTextField> createState() => _AlarmOffsetTextFieldState();
}

class _AlarmOffsetTextFieldState extends State<AlarmOffsetTextField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.value != null){
      _textEditingController.text = widget.value!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AlarmOffsetTextField oldWidget) {
    if(oldWidget.value != widget.value && widget.value != null){
      _textEditingController.text = widget.value!;
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
      keyboardType: TextInputType.number,
      hintText: context.strings.alarm_offset_value_field_hint,
      errorWidget: !widget.isValid ? ErrorText(
          errorText: (){
            if (widget.validator.displayError?.isInvalidValue ?? false) {
              return context.strings.alarm_offset_value_invalid;
            }
            return context.strings.generic_error_message;
          }()
      ) : null
    );
  }
}