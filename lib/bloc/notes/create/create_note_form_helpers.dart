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

class RecurrenceFormElements {
  const RecurrenceFormElements({
    this.selectedRecurrenceStartDate,
    this.selectedRecurrenceEndDate,
    this.hasChosenInterval = true,
    this.selectedIntervalRecurrenceType,
    this.selectedIntervalRecurrenceNumber,
    this.selectedIntervalRecurrenceStartDate,
    this.selectedIntervalRecurrenceEndDate,
    this.selectedDayBasedRecurrenceType,
    this.selectedDayBasedRecurrenceNumber,
    this.selectedDayBasedRecurrenceWeekday,
    this.alarmsForRecurrence = const [],
  });

  final DateTime? selectedRecurrenceStartDate;
  final DateTime? selectedRecurrenceEndDate;

  final bool hasChosenInterval; //Either interval or day-based recurrence
  //e.g. (every 3 days) vs (every Monday or every 5th of the month)
  final RecurrenceType? selectedIntervalRecurrenceType;
  final int? selectedIntervalRecurrenceNumber;
  final DateTime? selectedIntervalRecurrenceStartDate;
  final DateTime? selectedIntervalRecurrenceEndDate;

  final RecurrenceType? selectedDayBasedRecurrenceType;
  final int? selectedDayBasedRecurrenceNumber; //e.g. 5th of the month
  final int? selectedDayBasedRecurrenceWeekday; //e.g. Monday

  final List<AlarmFormElements> alarmsForRecurrence;

  RecurrenceFormElements copyWith({
    DateTime? selectedRecurrenceStartDate,
    DateTime? selectedRecurrenceEndDate,
    bool? hasChosenInterval,
    RecurrenceType? selectedIntervalRecurrenceType,
    int? selectedIntervalRecurrenceNumber,
    DateTime? selectedIntervalRecurrenceStartDate,
    DateTime? selectedIntervalRecurrenceEndDate,
    RecurrenceType? selectedDayBasedRecurrenceType,
    int? selectedDayBasedRecurrenceNumber,
    int? selectedDayBasedRecurrenceWeekday,
    List<AlarmFormElements>? alarmsForRecurrence,
  }) {
    return RecurrenceFormElements(
      selectedRecurrenceStartDate: selectedRecurrenceStartDate ?? this.selectedRecurrenceStartDate,
      selectedRecurrenceEndDate: selectedRecurrenceEndDate ?? this.selectedRecurrenceEndDate,
      hasChosenInterval: hasChosenInterval ?? this.hasChosenInterval,
      selectedIntervalRecurrenceType: selectedIntervalRecurrenceType ?? this.selectedIntervalRecurrenceType,
      selectedIntervalRecurrenceNumber: selectedIntervalRecurrenceNumber ?? this.selectedIntervalRecurrenceNumber,
      selectedIntervalRecurrenceStartDate: selectedIntervalRecurrenceStartDate ?? this.selectedIntervalRecurrenceStartDate,
      selectedIntervalRecurrenceEndDate: selectedIntervalRecurrenceEndDate ?? this.selectedIntervalRecurrenceEndDate,
      selectedDayBasedRecurrenceType: selectedDayBasedRecurrenceType ?? this.selectedDayBasedRecurrenceType,
      selectedDayBasedRecurrenceNumber: selectedDayBasedRecurrenceNumber ?? this.selectedDayBasedRecurrenceNumber,
      selectedDayBasedRecurrenceWeekday: selectedDayBasedRecurrenceWeekday ?? this.selectedDayBasedRecurrenceWeekday,
      alarmsForRecurrence: alarmsForRecurrence ?? this.alarmsForRecurrence,
    );
  }
}