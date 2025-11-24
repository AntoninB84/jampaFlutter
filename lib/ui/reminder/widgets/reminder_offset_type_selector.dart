
import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/reminder_offset_type_enum.dart';

/// A dropdown selector for choosing the reminder offset type (days, hours, minutes).
class ReminderOffsetTypeSelector extends StatelessWidget {
  const ReminderOffsetTypeSelector({super.key,
    required this.selectedValue,
    required this.onChanged
  });

  final ReminderOffsetType selectedValue;
  final Function(ReminderOffsetType?) onChanged;

  /// Returns the localized label for the given [reminderOffsetType].
  String getReminderOffsetTypeLabel(ReminderOffsetType reminderOffsetType, BuildContext context) {
    switch (reminderOffsetType) {
      case ReminderOffsetType.days:
        return context.strings.reminder_offset_type_days;
      case ReminderOffsetType.hours:
        return context.strings.reminder_offset_type_hours;
      case ReminderOffsetType.minutes:
        return context.strings.reminder_offset_type_minutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ReminderOffsetType>(
        decoration: InputDecoration(
          labelText: context.strings.reminder_offset_type_field_title,
          border: OutlineInputBorder(
              borderRadius: kRadius8
          ),
        ),
        dropdownColor: Theme.of(context).popupMenuTheme.color,
        borderRadius: kRadius12,
        value: selectedValue,
        items: ReminderOffsetType.values.map((reminderOffsetType) {
          return DropdownMenuItem<ReminderOffsetType>(
            value: reminderOffsetType,
            child: Text(getReminderOffsetTypeLabel(reminderOffsetType, context)),
          );
        }).toList(),
        onChanged: onChanged
    );
  }
}