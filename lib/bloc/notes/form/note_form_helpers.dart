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

  /// The ID of the schedule this reminder is associated with
  final String scheduleId;
  /// The ID of the reminder itself
  final String reminderId;
  /// The creation timestamp of the reminder
  final DateTime? createdAt;

  /// The number of units (e.g., minutes, hours, days) before the event when the reminder should trigger
  final int selectedOffsetNumber;
  /// The type of offset (e.g., minutes, hours, days) for the reminder
  final ReminderOffsetType selectedOffsetType;
  /// Indicates whether the reminder is a notification or an alarm
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

/// Class that holds all form elements for single date schedule
class SingleDateFormElements {
  const SingleDateFormElements({
    required this.noteId,
    required this.scheduleId,
    this.createdAt,
    this.selectedStartDateTime,
    this.selectedEndDateTime,
  });

  /// The ID of the note this schedule is associated with
  final String noteId;

  /// The ID of the schedule itself
  final String scheduleId;

  /// The creation timestamp of the schedule
  final DateTime? createdAt;

  /// The selected start date and time for the schedule
  final DateTime? selectedStartDateTime;

  /// The selected end date and time for the schedule
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

/// Class that holds all form elements for recurrence date schedule
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

  /// The ID of the note this schedule is associated with
  final String noteId;

  /// The ID of the schedule itself
  final String scheduleId;

  /// The creation timestamp of the schedule
  final DateTime? createdAt;

  /// The selected start date and time for the schedule
  final DateTime? selectedStartDateTime;

  /// The selected end date and time for the schedule
  final DateTime? selectedEndDateTime;

  /// The selected end date for the recurrence (optional)
  final DateTime? selectedRecurrenceEndDate;

  /// The selected type of recurrence (e.g., daily, weekly, monthly, yearly)
  final RecurrenceType? selectedRecurrenceType;

  /// The selected interval for daily recurrence (e.g., every X days)
  final int? selectedRecurrenceDaysInterval;

  /// The selected interval for yearly recurrence (e.g., every X years)
  final int? selectedRecurrenceYearsInterval;

  /// The selected date of the month for monthly recurrence (e.g., 15th of every month)
  final int? selectedRecurrenceMonthDate;

  /// The selected weekdays for weekly recurrence (e.g., Monday, Wednesday)
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