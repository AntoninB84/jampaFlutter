
import 'package:jampa_flutter/data/models/Alarm.dart';

import '../../bloc/notes/create/create_note_form_helpers.dart';
import '../enums/alarm_offset_type_enum.dart';

extension AlarmExtension on AlarmEntity {
  Map<String, int> get formattedTime {
    Map<String, int> formatted = {
      'days': 0,
      'hours': 0,
      'minutes': 0,
    };
    if (offsetTimeInMinutes != null) {
      final duration = Duration(minutes: offsetTimeInMinutes!);
      formatted['days'] = duration.inDays;
      formatted['hours'] = duration.inHours.remainder(24);
      formatted['minutes'] = duration.inMinutes.remainder(60);
    }
    return formatted;
  }

  static Map<String, int> formattedTimeFromFormElements(AlarmFormElements alarmFormElements) {
    Map<String, int> formatted = {
      'days': 0,
      'hours': 0,
      'minutes': 0,
    };
    switch (alarmFormElements.selectedOffsetType) {
      case AlarmOffsetType.days:
        formatted['days'] = alarmFormElements.selectedOffsetNumber;
        break;
      case AlarmOffsetType.hours:
        formatted['hours'] = alarmFormElements.selectedOffsetNumber;
        break;
      case AlarmOffsetType.minutes:
        formatted['minutes'] = alarmFormElements.selectedOffsetNumber;
        break;
    }
    return formatted;
  }
}