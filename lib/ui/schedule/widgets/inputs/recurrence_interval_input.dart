import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/ui/widgets/inputs/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';

class RecurrenceIntervalTextField extends StatefulWidget {
  const RecurrenceIntervalTextField({super.key,
    this.value,
    this.isValid = true,
    required this.validator,
    required this.onChanged,
    required this.hintText,
    this.errorWidget,
  });

  final String? value;
  final bool isValid;
  final FormzInput validator;
  final Function(String) onChanged;
  
  final String hintText;
  final Widget? errorWidget;

  @override
  State<RecurrenceIntervalTextField> createState() => _RecurrenceIntervalTextFieldState();
}

class _RecurrenceIntervalTextFieldState extends State<RecurrenceIntervalTextField> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if(widget.value != null){
      _textEditingController.text = widget.value!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RecurrenceIntervalTextField oldWidget) {
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
      hintText: widget.hintText,
      errorWidget: widget.errorWidget
    );
  }
}