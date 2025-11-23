import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/enums/weekdays_enum.dart';

import '../../../utils/enums/reminder_offset_type_enum.dart';

/// Class that holds all form elements for reminder
class ReminderFormElements {
  const ReminderFormElements({
    required this.scheduleId,
    required this.reminderId,
    this.createdAt,
    required this.selectedOffsetNumber,
    required this.selectedOffsetType,
    this.isNotification = true,
  });

  final String scheduleId;
  final String reminderId;
  final DateTime? createdAt;

  final int selectedOffsetNumber;
  final ReminderOffsetType selectedOffsetType;
  final bool isNotification;

  ReminderFormElements copyWith({
    String? scheduleId,
    String? reminderId,
    DateTime? createdAt,
    int? selectedOffsetNumber,
    ReminderOffsetType? selectedOffsetType,
    bool? isNotification,
  }) {
    return ReminderFormElements(
      scheduleId: scheduleId ?? this.scheduleId,
      reminderId: reminderId ?? this.reminderId,
      createdAt: createdAt ?? this.createdAt,
      selectedOffsetNumber: selectedOffsetNumber ?? this.selectedOffsetNumber,
      selectedOffsetType: selectedOffsetType ?? this.selectedOffsetType,
      isNotification: isNotification ?? this.isNotification,
    );
  }
}

/// Class that holds all form elements for single date
class SingleDateFormElements {
  const SingleDateFormElements({
    required this.noteId,
    required this.scheduleId,
    this.createdAt,
    this.selectedStartDateTime,
    this.selectedEndDateTime,
  });

  final String noteId;
  final String scheduleId;
  final DateTime? createdAt;

  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;

  SingleDateFormElements copyWith({
    String? noteId,
    String? scheduleId,
    DateTime? createdAt,
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
  }) {
    return SingleDateFormElements(
      noteId: noteId ?? this.noteId,
      scheduleId: scheduleId ?? this.scheduleId,
      createdAt: createdAt ?? this.createdAt,
      selectedStartDateTime: selectedStartDateTime ?? this.selectedStartDateTime,
      selectedEndDateTime: selectedEndDateTime ?? this.selectedEndDateTime,
    );
  }
}

/// Class that holds all form elements for recurrence date
class RecurrenceFormElements {
  const RecurrenceFormElements({
    required this.noteId,
    required this.scheduleId,
    this.createdAt,
    this.selectedStartDateTime,
    this.selectedEndDateTime,
    this.selectedRecurrenceEndDate,
    this.selectedRecurrenceType,
    this.selectedRecurrenceDaysInterval,
    this.selectedRecurrenceYearsInterval,
    this.selectedRecurrenceMonthDate,
    this.selectedRecurrenceWeekdays,
  });

  final String noteId;
  final String scheduleId;
  final DateTime? createdAt;

  final DateTime? selectedStartDateTime;
  final DateTime? selectedEndDateTime;
  final DateTime? selectedRecurrenceEndDate;

  final RecurrenceType? selectedRecurrenceType;
  final int? selectedRecurrenceDaysInterval;
  final int? selectedRecurrenceYearsInterval;
  final int? selectedRecurrenceMonthDate;
  final List<WeekdaysEnum>? selectedRecurrenceWeekdays;

  RecurrenceFormElements copyWith({
    String? noteId,
    String? scheduleId,
    DateTime? createdAt,
    DateTime? selectedStartDateTime,
    DateTime? selectedEndDateTime,
    DateTime? selectedRecurrenceEndDate,
    RecurrenceType? selectedRecurrenceType,
    int? selectedRecurrenceDaysInterval,
    int? selectedRecurrenceYearsInterval,
    int? selectedRecurrenceMonthDate,
    List<WeekdaysEnum>? selectedRecurrenceWeekdays,
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
    );
  }
}