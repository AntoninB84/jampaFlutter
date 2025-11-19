
import 'package:flutter/material.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/alarm_offset_type_enum.dart';

class AlarmOffsetTypeSelector extends StatelessWidget {
  const AlarmOffsetTypeSelector({super.key,
    required this.selectedValue,
    required this.onChanged
  });

  final ReminderOffsetType selectedValue;
  final Function(ReminderOffsetType?) onChanged;

  String getAlarmOffsetTypeLabel(ReminderOffsetType alarmOffsetType, BuildContext context) {
    switch (alarmOffsetType) {
      case ReminderOffsetType.days:
        return context.strings.alarm_offset_type_days;
      case ReminderOffsetType.hours:
        return context.strings.alarm_offset_type_hours;
      case ReminderOffsetType.minutes:
        return context.strings.alarm_offset_type_minutes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ReminderOffsetType>(
        decoration: InputDecoration(
          labelText: context.strings.alarm_offset_type_field_title,
          border: OutlineInputBorder(
              borderRadius: kRadius8
          ),
        ),
        dropdownColor: Theme.of(context).popupMenuTheme.color,
        borderRadius: kRadius12,
        value: selectedValue,
        items: ReminderOffsetType.values.map((alarmOffsetType) {
          return DropdownMenuItem<ReminderOffsetType>(
            value: alarmOffsetType,
            child: Text(getAlarmOffsetTypeLabel(alarmOffsetType, context)),
          );
        }).toList(),
        onChanged: onChanged
    );
  }
}