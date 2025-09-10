
import 'package:drift/drift.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/enums/weekdays_enum.dart';
import '../database.dart';
import 'note.dart';

@UseRowClass(ScheduleEntity)
class ScheduleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteId => integer().customConstraint('NOT NULL REFERENCES note_table(id) ON DELETE CASCADE')();
  DateTimeColumn get startDateTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endDateTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get recurrenceType => text().nullable()();
  IntColumn get recurrenceInterval => integer().nullable()();
  IntColumn get recurrenceDay => integer().nullable()();
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()();
}

class ScheduleEntity {
  final int? id;
  final int noteId;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? recurrenceType; // e.g., 'daily', 'weekly', 'monthly'
  final int? recurrenceInterval; // e.g., every 2 days/weeks/months
  final int? recurrenceDay; // e.g., day of the week for weekly recurrence
  final DateTime? recurrenceEndDate; // Optional end date for the recurrence

  ScheduleEntity({
    this.id,
    required this.noteId,
    required this.startDateTime,
    this.endDateTime,
    required this.createdAt,
    required this.updatedAt,
    this.recurrenceType,
    this.recurrenceInterval,
    this.recurrenceDay,
    this.recurrenceEndDate,
  });

  ScheduleTableCompanion toCompanion() {
    return ScheduleTableCompanion(
      id: id == null ? Value.absent() : Value(id!),
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
        'startDateTime: $startDateTime, '
        'endDateTime: $endDateTime, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'recurrenceType: $recurrenceType, '
        'recurrenceInterval: $recurrenceInterval, '
        'recurrenceDay: $recurrenceDay, '
        'recurrenceEndDate: $recurrenceEndDate'
      '}';
  }

  ScheduleEntity copyWith({
    int? id,
    int? noteId,
    DateTime? startDateTime,
    DateTime? endDateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? recurrenceType,
    int? recurrenceInterval,
    int? recurrenceDay,
    DateTime? recurrenceEndDate,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceDay: recurrenceDay ?? this.recurrenceDay,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
    );
  }

  ScheduleEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        noteId = json['noteId'] as int,
        startDateTime = json['startDateTime'] != null ? DateTime.parse(json['startDateTime'] as String) : null,
        endDateTime = json['endDateTime'] != null ? DateTime.parse(json['endDateTime'] as String) : null,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String),
        recurrenceType = json['recurrenceType'] as String?,
        recurrenceInterval = json['recurrenceInterval'] as int?,
        recurrenceDay = json['recurrenceDay'] as int?,
        recurrenceEndDate = json['recurrenceEndDate'] != null ? DateTime.parse(json['recurrenceEndDate'] as String) : null;


  SingleDateFormElements toSingleDateFormElements() {
    return SingleDateFormElements(
      noteId: noteId,
      scheduleId: id,
      selectedStartDateTime: startDateTime,
      selectedEndDateTime: endDateTime,
      createdAt: createdAt
    );
  }

  static ScheduleEntity fromSingleDateFormElements(SingleDateFormElements elements, int noteId) {
    return ScheduleEntity(
      id: elements.scheduleId,
      noteId: noteId,
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

    switch(RecurrenceType.fromString(recurrenceType ?? '')){
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
      selectedRecurrenceType: recurrenceType != null ? RecurrenceType.fromString(recurrenceType!) : null,
      selectedRecurrenceEndDate: recurrenceEndDate,
      selectedRecurrenceDaysInterval: recurrenceDaysInterval,
      selectedRecurrenceYearsInterval: recurrenceYearsInterval,
      selectedRecurrenceMonthDate: recurrenceMonthDate,
      selectedRecurrenceWeekdays: recurrenceWeekDays
    );
  }

  static ScheduleEntity fromRecurrenceFormElements(RecurrenceFormElements elements, int noteId) {

    String? recurrenceType;
    int? recurrenceInterval;
    int? recurrenceDay;

    switch(elements.selectedRecurrenceType){
      case RecurrenceType.intervalDays: {
        recurrenceType = RecurrenceType.intervalDays.name;
        recurrenceInterval = elements.selectedRecurrenceDaysInterval;
        break;
      }
      case RecurrenceType.dayBasedWeekly: {
        recurrenceType = RecurrenceType.dayBasedWeekly.name;
        if(elements.selectedRecurrenceWeekdays?.isNotEmpty ?? false){
          // Join the list of integers into a single integer (e.g., [1,3,5] -> 135)
          recurrenceDay = int.parse(elements.selectedRecurrenceWeekdays!
              .map((weekday){ return weekday.asInt;}).toList().join() //TODO test
          );
        }
        break;
      }
      case RecurrenceType.dayBasedMonthly: {
        recurrenceType = RecurrenceType.dayBasedMonthly.name;
        recurrenceDay = elements.selectedRecurrenceMonthDate;
        break;
      }
      case RecurrenceType.intervalYears: {
        recurrenceType = RecurrenceType.intervalYears.name;
        recurrenceInterval = elements.selectedRecurrenceYearsInterval;
        break;
      }
      default: break;
    }

    return ScheduleEntity(
      id: elements.scheduleId,
      noteId: noteId,
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