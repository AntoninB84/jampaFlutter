
import 'package:drift/drift.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';

import '../../utils/enums/reminder_offset_type_enum.dart';
import '../database.dart';

@UseRowClass(ReminderEntity)
class ReminderTable extends Table {
  TextColumn get id => text()();
  TextColumn get scheduleId => text().customConstraint('NOT NULL REFERENCES schedule_table(id) ON DELETE CASCADE')();
  IntColumn get offsetValue => integer()();
  TextColumn get offsetType => textEnum<ReminderOffsetType>()();
  BoolColumn get isNotification => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ReminderEntity {
  final String id;
  final String scheduleId;
  final int offsetValue;
  final ReminderOffsetType offsetType;
  final bool isNotification; // true if the alarm should be silent
  final DateTime createdAt;
  final DateTime updatedAt;

  ReminderEntity({
    required this.id,
    required this.scheduleId,
    required this.offsetValue,
    required this.offsetType,
    this.isNotification = true,
    required this.createdAt,
    required this.updatedAt,
  });

  ReminderTableCompanion toCompanion() {
    return ReminderTableCompanion(
      id: Value(id),
      scheduleId: Value(scheduleId),
      offsetValue: Value(offsetValue),
      offsetType: Value(offsetType),
      isNotification: Value(isNotification),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  @override
  String toString() {
    return 'ReminderEntity{'
        'id: $id, '
        'scheduleId: $scheduleId, '
        'offsetValue: $offsetValue, '
        'reminderOffsetType: $offsetType, '
        'isNotification: $isNotification, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        '}';
  }

  ReminderEntity copyWith({
    String? id,
    String? scheduleId,
    int? offsetValue,
    ReminderOffsetType? offsetType,
    bool? isNotification,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderEntity(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      offsetValue: offsetValue ?? this.offsetValue,
      offsetType: offsetType ?? this.offsetType,
      isNotification: isNotification ?? this.isNotification,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ReminderEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        scheduleId = json['scheduleId'] as String,
        offsetValue = json['offsetValue'] as int? ?? 0,
        offsetType = ReminderOffsetType.values.firstWhere(
            (e) => e.name == (json['offsetType'] as String?),
            orElse: () => ReminderOffsetType.minutes),
        isNotification = json['isNotification'] as bool? ?? true,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String);

  static List<ReminderEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => ReminderEntity.fromJson(json)).toList();
  }

  ReminderFormElements toReminderFormElements() {
    return ReminderFormElements(
      scheduleId: scheduleId,
      reminderId: id,
      createdAt: createdAt,
      selectedOffsetNumber: offsetValue,
      selectedOffsetType: offsetType,
      isNotification: isNotification,
    );
  }

  static ReminderEntity fromReminderFormElements(ReminderFormElements elements) {
    return ReminderEntity(
      id: elements.reminderId,
      scheduleId: elements.scheduleId,
      offsetValue: elements.selectedOffsetNumber,
      offsetType: elements.selectedOffsetType ?? ReminderOffsetType.minutes,
      isNotification: elements.isNotification,
      createdAt: elements.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}