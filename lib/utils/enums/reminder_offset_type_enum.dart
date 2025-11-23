import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

enum ReminderOffsetType {
  minutes,
  hours,
  days;

  String getLabel(BuildContext context) {
    switch (this) {
      case ReminderOffsetType.days:
        return context.strings.reminder_offset_type_days;
      case ReminderOffsetType.hours:
        return context.strings.reminder_offset_type_hours;
      case ReminderOffsetType.minutes:
        return context.strings.reminder_offset_type_minutes;
    }
  }
}
