import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';

import '../../../utils/enums/alarm_offset_type_enum.dart';

class AlarmFormElements {
  const AlarmFormElements({
    required this.selectedOffsetNumber,
    required this.selectedOffsetType,
    this.isSilentAlarm = true,
  });

  final int selectedOffsetNumber;
  final AlarmOffsetType selectedOffsetType;
  final bool isSilentAlarm;

  AlarmFormElements copyWith({
    int? selectedOffsetNumber,
    AlarmOffsetType? selectedOffsetType,
    bool? isSilentAlarm,
  }) {
    return AlarmFormElements(
      selectedOffsetNumber: selectedOffsetNumber ?? this.selectedOffsetNumber,
      selectedOffsetType: selectedOffsetType ?? this.selectedOffsetType,
      isSilentAlarm: isSilentAlarm ?? this.isSilentAlarm,
    );
  }
}

class SingleDateFormElements {
  const SingleDateFormElements({
    this.selectedStartDateTime,
    this.selectedEndDateTime,
    this.alarmsForSingleDate,
  });

  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;
  final List<AlarmFormElements>? alarmsForSingleDate;

  SingleDateFormElements copyWith({
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
    List<AlarmFormElements>? alarmsForSingleDate,
  }) {
    return SingleDateFormElements(
      selectedStartDateTime: selectedStartDateTime ?? this.selectedStartDateTime,
      selectedEndDateTime: selectedEndDateTime ?? this.selectedEndDateTime,
      alarmsForSingleDate: alarmsForSingleDate ?? this.alarmsForSingleDate,
    );
  }
}

class RecurrenceFormElements {
  const RecurrenceFormElements({
    this.selectedStartDateTime,
    this.selectedEndDateTime,
    this.selectedRecurrenceEndDate,
    this.selectedRecurrenceType,
    this.selectedRecurrenceDaysInterval,
    this.selectedRecurrenceYearsInterval,
    this.selectedRecurrenceMonthDate,
    this.selectedRecurrenceWeekdays,
    this.alarmsForRecurrence = const [],
  });

  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;
  final DateTime? selectedRecurrenceEndDate;

  final RecurrenceType? selectedRecurrenceType;
  final int? selectedRecurrenceDaysInterval;
  final int? selectedRecurrenceYearsInterval;
  final int? selectedRecurrenceMonthDate;
  final List<int>? selectedRecurrenceWeekdays;

  final List<AlarmFormElements> alarmsForRecurrence;

  RecurrenceFormElements copyWith({
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
    DateTime? selectedRecurrenceEndDate,
    RecurrenceType? selectedRecurrenceType,
    int? selectedRecurrenceDaysInterval,
    int? selectedRecurrenceYearsInterval,
    int? selectedRecurrenceMonthDate,
    List<int>? selectedRecurrenceWeekdays,
    List<AlarmFormElements>? alarmsForRecurrence,
  }) {
    return RecurrenceFormElements(
      selectedStartDateTime: selectedStartDateTime ?? this.selectedStartDateTime,
      selectedEndDateTime: selectedEndDateTime ?? this.selectedEndDateTime,
      selectedRecurrenceEndDate: selectedRecurrenceEndDate ?? this.selectedRecurrenceEndDate,
      selectedRecurrenceType: selectedRecurrenceType ?? this.selectedRecurrenceType,
      selectedRecurrenceDaysInterval: selectedRecurrenceDaysInterval ?? this.selectedRecurrenceDaysInterval,
      selectedRecurrenceYearsInterval: selectedRecurrenceYearsInterval ?? this.selectedRecurrenceYearsInterval,
      selectedRecurrenceMonthDate: selectedRecurrenceMonthDate ?? this.selectedRecurrenceMonthDate,
      selectedRecurrenceWeekdays: selectedRecurrenceWeekdays ?? this.selectedRecurrenceWeekdays,
      alarmsForRecurrence: alarmsForRecurrence ?? this.alarmsForRecurrence,
    );
  }
}