import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

/// Enum representing different types of reminder offsets.
enum ReminderOffsetType {
  minutes,
  hours,
  days;

  /// Returns a localized label for the enum value.
  String getLabel(BuildContext context) {
    switch (this) {
      case .days:
        return context.strings.reminder_offset_type_days;
      case .hours:
        return context.strings.reminder_offset_type_hours;
      case .minutes:
        return context.strings.reminder_offset_type_minutes;
    }
  }
}
