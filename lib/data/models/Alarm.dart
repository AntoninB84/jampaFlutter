
import 'package:drift/drift.dart';
import '../database.dart';
import 'schedule.dart';

@UseRowClass(AlarmEntity)
class AlarmTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scheduleId => integer().customConstraint('NOT NULL REFERENCES schedule_table(id) ON DELETE CASCADE')();
  IntColumn get offsetTimeInMinutes => integer().nullable()();
  BoolColumn get isSilent => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AlarmEntity {
  final int? id;
  final int scheduleId;
  final int? offsetTimeInMinutes; // e.g., -10 for 10 minutes before the event
  final bool isSilent; // true if the alarm should be silent
  final DateTime createdAt;
  final DateTime updatedAt;

  AlarmEntity({
    this.id,
    required this.scheduleId,
    this.offsetTimeInMinutes,
    this.isSilent = true,
    required this.createdAt,
    required this.updatedAt,
  });

  AlarmTableCompanion toCompanion() {
    return AlarmTableCompanion(
      id: id == null ? Value.absent() : Value(id!),
      scheduleId: Value(scheduleId),
      offsetTimeInMinutes: offsetTimeInMinutes == null ? Value.absent() : Value(offsetTimeInMinutes!),
      isSilent: Value(isSilent),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  @override
  String toString() {
    return 'AlarmEntity{'
        'id: $id, '
        'scheduleId: $scheduleId, '
        'offsetTimeInMinutes: $offsetTimeInMinutes, '
        'isSilent: $isSilent, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        '}';
  }

  AlarmEntity copyWith({
    int? id,
    int? scheduleId,
    int? offsetTimeInMinutes,
    bool? isSilent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlarmEntity(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      offsetTimeInMinutes: offsetTimeInMinutes ?? this.offsetTimeInMinutes,
      isSilent: isSilent ?? this.isSilent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  AlarmEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        scheduleId = json['scheduleId'] as int,
        offsetTimeInMinutes = json['offsetTimeInMinutes'] as int?,
        isSilent = json['isSilent'] as bool? ?? true,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String);
}