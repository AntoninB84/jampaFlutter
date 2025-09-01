
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
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
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedDateTime != null
              ? '${"${selectedDateTime!.toLocal()}".split(' ')[0]} ${TimeOfDay.fromDateTime(selectedDateTime!).format(context)}'
              : 'Select date and time',
        ),
      ),
    );
  }
}