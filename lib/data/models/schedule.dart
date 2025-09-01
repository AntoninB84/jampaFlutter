
import 'package:drift/drift.dart';
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

}