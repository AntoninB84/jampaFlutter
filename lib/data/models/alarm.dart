
import 'package:drift/drift.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import '../../utils/enums/alarm_offset_type_enum.dart';
import '../database.dart';
import 'schedule.dart';

@UseRowClass(AlarmEntity)
class AlarmTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scheduleId => integer().customConstraint('NOT NULL REFERENCES schedule_table(id) ON DELETE CASCADE')();
  IntColumn get offsetValue => integer()();
  TextColumn get offsetType => textEnum<AlarmOffsetType>()();
  BoolColumn get isSilent => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AlarmEntity {
  final int? id;
  final int scheduleId;
  final int offsetValue;
  final AlarmOffsetType offsetType;
  final bool isSilent; // true if the alarm should be silent
  final DateTime createdAt;
  final DateTime updatedAt;

  AlarmEntity({
    this.id,
    required this.scheduleId,
    required this.offsetValue,
    required this.offsetType,
    this.isSilent = true,
    required this.createdAt,
    required this.updatedAt,
  });

  AlarmTableCompanion toCompanion() {
    return AlarmTableCompanion(
      id: id == null ? Value.absent() : Value(id!),
      scheduleId: Value(scheduleId),
      offsetValue: Value(offsetValue),
      offsetType: Value(offsetType),
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
        'offsetValue: $offsetValue, '
        'alarmOffsetType: $offsetType, '
        'isSilent: $isSilent, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        '}';
  }

  AlarmEntity copyWith({
    int? id,
    int? scheduleId,
    int? offsetValue,
    AlarmOffsetType? alarmOffsetType,
    bool? isSilent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlarmEntity(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      offsetValue: offsetValue ?? this.offsetValue,
      offsetType: alarmOffsetType ?? this.offsetType,
      isSilent: isSilent ?? this.isSilent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  AlarmEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        scheduleId = json['scheduleId'] as int,
        offsetValue = json['offsetValue'] as int? ?? 0,
        offsetType = AlarmOffsetType.values.firstWhere(
            (e) => e.name == (json['offsetType'] as String?),
            orElse: () => AlarmOffsetType.minutes),
        isSilent = json['isSilent'] as bool? ?? true,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String);

  static List<AlarmEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => AlarmEntity.fromJson(json)).toList();
  }

  AlarmFormElements toAlarmFormElements() {
    return AlarmFormElements(
      scheduleId: scheduleId,
      alarmId: id,
      createdAt: createdAt,
      selectedOffsetNumber: offsetValue,
      selectedOffsetType: offsetType,
      isSilentAlarm: isSilent,
    );
  }

  static AlarmEntity fromAlarmFormElements(AlarmFormElements elements, int scheduleId) {
    return AlarmEntity(
      id: elements.alarmId,
      scheduleId: scheduleId,
      offsetValue: elements.selectedOffsetNumber,
      offsetType: elements.selectedOffsetType ?? AlarmOffsetType.minutes,
      isSilent: elements.isSilentAlarm,
      createdAt: elements.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}