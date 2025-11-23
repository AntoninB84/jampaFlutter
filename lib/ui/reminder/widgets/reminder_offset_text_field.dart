import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/ui/widgets/inputs/custom_text_field.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';

class ReminderOffsetTextField extends StatefulWidget {
  const ReminderOffsetTextField({super.key,
    this.value,
    required this.validator,
    required this.onChanged,
  });

  final String? value;
  final PositiveValueValidator validator;
  final Function(String) onChanged;

  @override
  State<ReminderOffsetTextField> createState() => _ReminderOffsetTextFieldState();
}

class _ReminderOffsetTextFieldState extends State<ReminderOffsetTextField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.value != null){
      _textEditingController.text = widget.value!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReminderOffsetTextField oldWidget) {
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
      hintText: context.strings.reminder_offset_value_field_hint,
      errorWidget: (!widget.validator.isPure && widget.validator.isNotValid) ? ErrorText(
          errorText: (){
            if (widget.validator.displayError?.isInvalidValue ?? false) {
              return context.strings.reminder_offset_value_invalid;
            }
            return context.strings.generic_error_message;
          }()
      ) : null
    );
  }
}