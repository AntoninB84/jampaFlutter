import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

enum AlarmOffsetType {
  minutes,
  hours,
  days;

  String getLabel(BuildContext context) {
    switch (this) {
      case AlarmOffsetType.days:
        return context.strings.alarm_offset_type_days;
      case AlarmOffsetType.hours:
        return context.strings.alarm_offset_type_hours;
      case AlarmOffsetType.minutes:
        return context.strings.alarm_offset_type_minutes;
    }
  }
}
