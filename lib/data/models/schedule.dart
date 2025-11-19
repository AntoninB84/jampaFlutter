
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/enums/weekdays_enum.dart';

import '../database.dart';
import 'note.dart';

@UseRowClass(ScheduleEntity)
class ScheduleTable extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().customConstraint('NOT NULL REFERENCES note_table(id) ON DELETE CASCADE')();
  DateTimeColumn get startDateTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endDateTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get recurrenceType => textEnum<RecurrenceType>().nullable()();
  IntColumn get recurrenceInterval => integer().nullable()();
  IntColumn get recurrenceDay => integer().nullable()();
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()();
}

class ScheduleEntity {
  final String id;
  final String noteId;
  NoteEntity? note;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RecurrenceType? recurrenceType;
  final int? recurrenceInterval; // e.g., every 2 days/years
  final int? recurrenceDay; // e.g., day of the month / days of the week
  final DateTime? recurrenceEndDate; // Optional end date for the recurrence
  List<ReminderEntity>? reminders;

  ScheduleEntity({
    required this.id,
    required this.noteId,
    this.note,
    required this.startDateTime,
    this.endDateTime,
    required this.createdAt,
    required this.updatedAt,
    this.recurrenceType,
    this.recurrenceInterval,
    this.recurrenceDay,
    this.recurrenceEndDate,
    this.reminders
  });

  ScheduleTableCompanion toCompanion() {
    return ScheduleTableCompanion(
      id: Value(id),
      noteId: Value(noteId),
      startDateTime: Value(startDateTime!),
      endDateTime: endDateTime == null ? Value.absent() : Value(endDateTime!),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      recurrenceType: recurrenceType == null ? Value.absent() : Value(recurrenceType!),
      recurrenceInterval: recurrenceInterval == null ? Value.absent() : Value(recurrenceInterval!),
      recurrenceDay: recurrenceDay == null ? Value.absent() : Value(recurrenceDay!),
      recurrenceEndDate: recurrenceEndDate == null ? Value.absent() : Value(recurrenceEndDate!),
    );
  }

  @override
  String toString() {
    return 'ScheduleEntity{'
        'id: $id, '
        'noteId: $noteId, '
        'note: $note, '
        'startDateTime: $startDateTime, '
        'endDateTime: $endDateTime, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'recurrenceType: $recurrenceType, '
        'recurrenceInterval: $recurrenceInterval, '
        'recurrenceDay: $recurrenceDay, '
        'recurrenceEndDate: $recurrenceEndDate, '
        'alarms: $reminders'
      '}';
  }

  ScheduleEntity copyWith({
    String? id,
    String? noteId,
    NoteEntity? note,
    DateTime? startDateTime,
    DateTime? endDateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    RecurrenceType? recurrenceType,
    int? recurrenceInterval,
    int? recurrenceDay,
    DateTime? recurrenceEndDate,
    List<ReminderEntity>? reminders
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      note: note ?? this.note,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceDay: recurrenceDay ?? this.recurrenceDay,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      reminders: reminders ?? this.reminders,
    );
  }

  ScheduleEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        noteId = json['noteId'] as String,
        note = NoteEntity.fromJson(json['note']),
        startDateTime = json['startDateTime'] != null ? DateTime.parse(json['startDateTime'] as String) : null,
        endDateTime = json['endDateTime'] != null ? DateTime.parse(json['endDateTime'] as String) : null,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String),
        recurrenceType = RecurrenceType.values.firstWhereOrNull(
                (e) => e.name == (json['recurrencyType'] as String?)),
        recurrenceInterval = json['recurrenceInterval'] as int?,
        recurrenceDay = json['recurrenceDay'] as int?,
        recurrenceEndDate = json['recurrenceEndDate'] != null ? DateTime.parse(json['recurrenceEndDate'] as String) : null,
        reminders = ReminderEntity.fromJsonArray(json['reminders'])
  ;


  SingleDateFormElements toSingleDateFormElements() {
    return SingleDateFormElements(
      noteId: noteId,
      scheduleId: id,
      selectedStartDateTime: startDateTime,
      selectedEndDateTime: endDateTime,
      createdAt: createdAt
    );
  }

  static ScheduleEntity fromSingleDateFormElements(SingleDateFormElements elements) {
    return ScheduleEntity(
      id: elements.scheduleId,
      noteId: elements.noteId,
      startDateTime: elements.selectedStartDateTime,
      endDateTime: elements.selectedEndDateTime,
      createdAt: elements.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  RecurrenceFormElements toRecurrenceFormElements() {

    int? recurrenceDaysInterval;
    int? recurrenceYearsInterval;
    int? recurrenceMonthDate;
    List<WeekdaysEnum> recurrenceWeekDays = [];

    switch(recurrenceType){
      case RecurrenceType.intervalDays: {
        recurrenceDaysInterval = recurrenceInterval;
        break;
      }
      case RecurrenceType.dayBasedWeekly: {
        if(recurrenceDay != null){
          String daysString = recurrenceDay!.toString();
          if(daysString.isNotEmpty){
            // Split the integer into its individual digits and convert to a list of integers
            recurrenceWeekDays = daysString.split("").map(
                    (e) => WeekdaysEnum.fromInt(int.parse(e))
            ).toList();
          }
        }
        break;
      }
      case RecurrenceType.dayBasedMonthly: {
        recurrenceMonthDate = recurrenceDay;
        break;
      }
      case RecurrenceType.intervalYears: {
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

  static ScheduleEntity fromRecurrenceFormElements(RecurrenceFormElements elements) {

    RecurrenceType? recurrenceType;
    int? recurrenceInterval;
    int? recurrenceDay;

    switch(elements.selectedRecurrenceType){
      case RecurrenceType.intervalDays: {
        recurrenceType = RecurrenceType.intervalDays;
        recurrenceInterval = elements.selectedRecurrenceDaysInterval;
        break;
      }
      case RecurrenceType.dayBasedWeekly: {
        recurrenceType = RecurrenceType.dayBasedWeekly;
        if(elements.selectedRecurrenceWeekdays?.isNotEmpty ?? false){
          // Join the list of integers into a single integer (e.g., [1,3,5] -> 135)
          recurrenceDay = int.parse(elements.selectedRecurrenceWeekdays!
              .map((weekday){ return weekday.asInt;}).toList().join()
          );
        }
        break;
      }
      case RecurrenceType.dayBasedMonthly: {
        recurrenceType = RecurrenceType.dayBasedMonthly;
        recurrenceDay = elements.selectedRecurrenceMonthDate;
        break;
      }
      case RecurrenceType.intervalYears: {
        recurrenceType = RecurrenceType.intervalYears;
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
      createdAt: elements.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      recurrenceType: recurrenceType,
      recurrenceInterval: recurrenceInterval,
      recurrenceDay: recurrenceDay,
      recurrenceEndDate: elements.selectedRecurrenceEndDate,
    );
  }
}