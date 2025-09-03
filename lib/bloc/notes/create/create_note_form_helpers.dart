import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';

import '../../../utils/enums/alarm_offset_type_enum.dart';

class AlarmFormElements {
  const AlarmFormElements({
    this.scheduleId,
    this.alarmId,
    this.createdAt,
    required this.selectedOffsetNumber,
    required this.selectedOffsetType,
    this.isSilentAlarm = true,
  });

  final int? scheduleId;
  final int? alarmId;
  final DateTime? createdAt;

  final int selectedOffsetNumber;
  final AlarmOffsetType selectedOffsetType;
  final bool isSilentAlarm;

  AlarmFormElements copyWith({
    int? scheduleId,
    int? alarmId,
    DateTime? createdAt,
    int? selectedOffsetNumber,
    AlarmOffsetType? selectedOffsetType,
    bool? isSilentAlarm,
  }) {
    return AlarmFormElements(
      scheduleId: scheduleId ?? this.scheduleId,
      alarmId: alarmId ?? this.alarmId,
      createdAt: createdAt ?? this.createdAt,
      selectedOffsetNumber: selectedOffsetNumber ?? this.selectedOffsetNumber,
      selectedOffsetType: selectedOffsetType ?? this.selectedOffsetType,
      isSilentAlarm: isSilentAlarm ?? this.isSilentAlarm,
    );
  }
}

class SingleDateFormElements {
  const SingleDateFormElements({
    this.noteId,
    this.scheduleId,
    this.createdAt,
    this.selectedStartDateTime,
    this.selectedEndDateTime,
    this.alarmsForSingleDate,
  });

  final int? noteId;
  final int? scheduleId;
  final DateTime? createdAt;

  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;
  final List<AlarmFormElements>? alarmsForSingleDate;

  SingleDateFormElements copyWith({
    int? noteId,
    int? scheduleId,
    DateTime? createdAt,
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
    List<AlarmFormElements>? alarmsForSingleDate,
  }) {
    return SingleDateFormElements(
      noteId: noteId ?? this.noteId,
      scheduleId: scheduleId ?? this.scheduleId,
      createdAt: createdAt ?? this.createdAt,
      selectedStartDateTime: selectedStartDateTime ?? this.selectedStartDateTime,
      selectedEndDateTime: selectedEndDateTime ?? this.selectedEndDateTime,
      alarmsForSingleDate: alarmsForSingleDate ?? this.alarmsForSingleDate,
    );
  }
}

class RecurrenceFormElements {
  const RecurrenceFormElements({
    this.noteId,
    this.scheduleId,
    this.createdAt,
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

  final int? noteId;
  final int? scheduleId;
  final DateTime? createdAt;

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
    int? noteId,
    int? scheduleId,
    DateTime? createdAt,
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
      noteId: noteId ?? this.noteId,
      scheduleId: scheduleId ?? this.scheduleId,
      createdAt: createdAt ?? this.createdAt,
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