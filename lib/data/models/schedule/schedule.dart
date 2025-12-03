
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/data/models/reminder/reminder.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/enums/weekdays_enum.dart';

import '../../database.dart';
import '../note/note.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

/// Definition of the Schedule table in the database
@drift.UseRowClass(ScheduleEntity)
class ScheduleTable extends drift.Table {
  drift.TextColumn get id => text()();
  drift.TextColumn get noteId => text().customConstraint('NOT NULL REFERENCES note_table(id) ON DELETE CASCADE')();
  drift.DateTimeColumn get startDateTime => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get endDateTime => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get updatedAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.TextColumn get recurrenceType => textEnum<RecurrenceType>().nullable()();
  drift.IntColumn get recurrenceInterval => integer().nullable()();
  drift.IntColumn get recurrenceDay => integer().nullable()();
  drift.DateTimeColumn get recurrenceEndDate => dateTime().nullable()();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

/// Schedule Entity Class
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ScheduleEntity with _$ScheduleEntity {
  const ScheduleEntity._();

  @Assert('id.isNotEmpty', 'Schedule id cannot be empty')
  @Assert('noteId.isNotEmpty', 'Note id cannot be empty')
  const factory ScheduleEntity({
    /// Unique identifier for the schedule (UUID)
    required String id,

    /// Identifier of the parent note
    required String noteId,

    /// The parent note entity. Can be null if not loaded
    @JsonKey(includeFromJson: false, includeToJson: false)
    NoteEntity? note,

    /// Start date and time of the schedule
    required DateTime? startDateTime,

    /// Optional end date and time of the schedule
    DateTime? endDateTime,

    /// Timestamp when the schedule was created
    required DateTime createdAt,

    /// Timestamp when the schedule was last updated
    required DateTime updatedAt,

    /// Type of recurrence for the schedule.
    /// Is null if the schedule is a single date schedule
    RecurrenceType? recurrenceType,

    /// Interval value for day-based or year-based recurrences.
    /// e.g., every 2 days/years
    int? recurrenceInterval,

    /// Day value for day-based weekly or monthly recurrences
    ///
    /// e.g., for weekly: days of the week as integer (e.g., 135 for Mon, Wed, Fri)
    ///
    /// e.g., for monthly: day of the month (e.g., 15 for the 15th of each month)
    int? recurrenceDay,

    /// Optional end date for the recurrence
    DateTime? recurrenceEndDate,

    /// List of reminders associated with the schedule
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<ReminderEntity>? reminders,
  }) = _ScheduleEntity;


  /// Converts the [ScheduleEntity] to a [ScheduleTableCompanion] for database operations
  ScheduleTableCompanion toCompanion() {
    return ScheduleTableCompanion(
      id: drift.Value(id),
      noteId: drift.Value(noteId),
      startDateTime: drift.Value(startDateTime!),
      endDateTime: endDateTime == null ? .absent() : drift.Value(endDateTime!),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
      recurrenceType: recurrenceType == null ? .absent() : drift.Value(recurrenceType!),
      recurrenceInterval: recurrenceInterval == null ? .absent() : drift.Value(recurrenceInterval!),
      recurrenceDay: recurrenceDay == null ? .absent() : drift.Value(recurrenceDay!),
      recurrenceEndDate: recurrenceEndDate == null ? .absent() : drift.Value(recurrenceEndDate!),
    );
  }

  factory ScheduleEntity.fromJson(Map<String, dynamic> json) => _$ScheduleEntityFromJson(json);


  /// Converts the [ScheduleEntity] to [SingleDateFormElements] for form handling
  SingleDateFormElements toSingleDateFormElements() {
    return SingleDateFormElements(
      noteId: noteId,
      scheduleId: id,
      selectedStartDateTime: startDateTime,
      selectedEndDateTime: endDateTime,
      createdAt: createdAt
    );
  }

  /// Creates a [ScheduleEntity] from [SingleDateFormElements] for data saving
  static ScheduleEntity fromSingleDateFormElements(SingleDateFormElements elements) {
    return ScheduleEntity(
      id: elements.scheduleId,
      noteId: elements.noteId,
      startDateTime: elements.selectedStartDateTime,
      endDateTime: elements.selectedEndDateTime,
      createdAt: elements.createdAt ?? .now(),
      updatedAt: .now(),
    );
  }

  /// Converts the [ScheduleEntity] to [RecurrenceFormElements] for form handling
  RecurrenceFormElements toRecurrenceFormElements() {

    int? recurrenceDaysInterval;
    int? recurrenceYearsInterval;
    int? recurrenceMonthDate;
    List<WeekdaysEnum> recurrenceWeekDays = [];

    switch(recurrenceType){
      case .intervalDays: {
        recurrenceDaysInterval = recurrenceInterval;
        break;
      }
      case .dayBasedWeekly: {
        if(recurrenceDay != null){
          String daysString = recurrenceDay!.toString();
          if(daysString.isNotEmpty){
            // Split the integer into its individual digits and convert to a list of integers
            recurrenceWeekDays = daysString.split("").map(
                    (e) => WeekdaysEnum.fromInt(.parse(e))
            ).toList();
          }
        }
        break;
      }
      case .dayBasedMonthly: {
        recurrenceMonthDate = recurrenceDay;
        break;
      }
      case .intervalYears: {
        recurrenceYearsInterval = recurrenceInterval;
        break;
      }
      default: break;
    }

    return RecurrenceFormElements(
      noteId: noteId,
      scheduleId: id,
      selectedStartDateTime: startDateTime,
      selectedEndDateTime: endDateTime,
      createdAt: createdAt,
      selectedRecurrenceType: recurrenceType,
      selectedRecurrenceEndDate: recurrenceEndDate,
      selectedRecurrenceDaysInterval: recurrenceDaysInterval,
      selectedRecurrenceYearsInterval: recurrenceYearsInterval,
      selectedRecurrenceMonthDate: recurrenceMonthDate,
      selectedRecurrenceWeekdays: recurrenceWeekDays
    );
  }

  /// Creates a [ScheduleEntity] from [RecurrenceFormElements] for data saving
  static ScheduleEntity fromRecurrenceFormElements(RecurrenceFormElements elements) {

    RecurrenceType? recurrenceType;
    int? recurrenceInterval;
    int? recurrenceDay;

    switch(elements.selectedRecurrenceType){
      case .intervalDays: {
        recurrenceType = .intervalDays;
        recurrenceInterval = elements.selectedRecurrenceDaysInterval;
        break;
      }
      case .dayBasedWeekly: {
        recurrenceType = .dayBasedWeekly;
        if(elements.selectedRecurrenceWeekdays?.isNotEmpty ?? false){
          // Join the list of integers into a single integer (e.g., [1,3,5] -> 135)
          recurrenceDay = .parse(elements.selectedRecurrenceWeekdays!
              .map((weekday){ return weekday.asInt;}).toList().join()
          );
        }
        break;
      }
      case .dayBasedMonthly: {
        recurrenceType = .dayBasedMonthly;
        recurrenceDay = elements.selectedRecurrenceMonthDate;
        break;
      }
      case .intervalYears: {
        recurrenceType = .intervalYears;
        recurrenceInterval = elements.selectedRecurrenceYearsInterval;
        break;
      }
      default: break;
    }

    return ScheduleEntity(
      id: elements.scheduleId,
      noteId: elements.noteId,
      startDateTime: elements.selectedStartDateTime,
      endDateTime: elements.selectedEndDateTime,
      createdAt: elements.createdAt ?? .now(),
      updatedAt: .now(),
      recurrenceType: recurrenceType,
      recurrenceInterval: recurrenceInterval,
      recurrenceDay: recurrenceDay,
      recurrenceEndDate: elements.selectedRecurrenceEndDate,
    );
  }
}