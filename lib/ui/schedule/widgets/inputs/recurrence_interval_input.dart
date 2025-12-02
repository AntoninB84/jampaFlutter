import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/ui/widgets/inputs/custom_text_field.dart';
import 'package:jampa_flutter/ui/widgets/error_text.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';

/// A text field for entering recurrence interval with validation and error display.
/// Serves for day-based recurrence intervals and year-based recurrence intervals.
class RecurrenceIntervalTextField extends StatefulWidget {
  const RecurrenceIntervalTextField({super.key,
    this.value,
    required this.validator,
    required this.onChanged,
    required this.hintText,
    this.errorWidget,
  });

  /// The current value of the text field.
  final String? value;

  /// The validator for the input value.
  /// Custom implementations of [FormzInput] can be used here.
  final FormzInput validator;

  /// Callback when the text field value changes.
  final Function(String) onChanged;

  /// The hint text to display when the field is empty.
  final String hintText;

  /// An optional custom widget to display error messages according to type of data.
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
      keyboardType: .number,
      hintText: widget.hintText,
      errorWidget: widget.errorWidget
    );
  }
}