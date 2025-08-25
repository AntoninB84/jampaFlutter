
import 'package:drift/drift.dart';
import '../database.dart';
import 'note.dart';

@UseRowClass(ScheduleEntity)
class ScheduleTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteId => integer().customConstraint('NOT NULL REFERENCES note_table(id) ON DELETE CASCADE')();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get recurrenceType => text().nullable()();
  IntColumn get recurrenceInterval => integer().nullable()();
  IntColumn get recurrenceDay => integer().nullable()();
}

class ScheduleEntity {
  final int? id;
  final int noteId;
  final DateTime? date;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? recurrenceType; // e.g., 'daily', 'weekly', 'monthly'
  final int? recurrenceInterval; // e.g., every 2 days/weeks/months
  final int? recurrenceDay; // e.g., day of the week for weekly recurrence

  ScheduleEntity({
    this.id,
    required this.noteId,
    required this.date,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.recurrenceType,
    this.recurrenceInterval,
    this.recurrenceDay,
  });

  ScheduleTableCompanion toCompanion() {
    return ScheduleTableCompanion(
      id: id == null ? Value.absent() : Value(id!),
      noteId: Value(noteId),
      date: Value(date!),
      endDate: endDate == null ? Value.absent() : Value(endDate!),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      recurrenceType: recurrenceType == null ? Value.absent() : Value(recurrenceType!),
      recurrenceInterval: recurrenceInterval == null ? Value.absent() : Value(recurrenceInterval!),
      recurrenceDay: recurrenceDay == null ? Value.absent() : Value(recurrenceDay!),
    );
  }

  @override
  String toString() {
    return 'ScheduleEntity{'
        'id: $id, '
        'noteId: $noteId, '
        'date: $date, '
        'endDate: $endDate, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'recurrenceType: $recurrenceType, '
        'recurrenceInterval: $recurrenceInterval, '
        'recurrenceDay: $recurrenceDay'
      '}';
  }

  ScheduleEntity copyWith({
    int? id,
    int? noteId,
    DateTime? date,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? recurrenceType,
    int? recurrenceInterval,
    int? recurrenceDay,
  }) {
    return ScheduleEntity(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      date: date ?? this.date,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceDay: recurrenceDay ?? this.recurrenceDay,
    );
  }

  ScheduleEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        noteId = json['noteId'] as int,
        date = json['date'] != null ? DateTime.parse(json['date'] as String) : null,
        endDate = json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String),
        recurrenceType = json['recurrenceType'] as String?,
        recurrenceInterval = json['recurrenceInterval'] as int?,
        recurrenceDay = json['recurrenceDay'] as int?;

}