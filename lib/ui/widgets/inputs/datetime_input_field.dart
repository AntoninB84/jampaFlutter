
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';

import '../../../utils/constants/styles/sizes.dart';

/// A custom input field widget for selecting date and time.
class DatetimeInputField extends StatefulWidget {
  const DatetimeInputField({
    super.key,
    required this.label,
    this.initialDateTime,
    this.errorText,
    this.onDateTimeSelected,
  });

  final String label;
  final DateTime? initialDateTime;
  final String? errorText;
  final ValueChanged<DateTime>? onDateTimeSelected;

  @override
  State<DatetimeInputField> createState() => _DatetimeInputFieldState();
}

class _DatetimeInputFieldState extends State<DatetimeInputField> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    selectedDateTime = widget.initialDateTime;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DatetimeInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted){
          setState(() {
            selectedDateTime = widget.initialDateTime;
          });
        }
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? .now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? .now()),
      );
      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          selectedDateTime = combined;
        });
        if (widget.onDateTimeSelected != null) {
          widget.onDateTimeSelected!(combined);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: widget.errorText,
          border: OutlineInputBorder(
            borderRadius: kRadius8
          ),
        ),
        child: Text(
          selectedDateTime != null
              ? selectedDateTime!.toFullFormat(context)
              : context.strings.datetime_hint,
        ),
      ),
    );
  }
}