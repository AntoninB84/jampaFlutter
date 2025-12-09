
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';

import '../../../utils/enums/reminder_offset_type_enum.dart';
import '../../database.dart';
import '../schedule/schedule.dart';
import '../note/note.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

/// Definition of the Reminder table in the database
@drift.UseRowClass(ReminderEntity)
class ReminderTable extends drift.Table {
  drift.TextColumn get id => text()();
  drift.TextColumn get scheduleId => text().customConstraint('NOT NULL REFERENCES schedule_table(id) ON DELETE CASCADE')();
  drift.TextColumn get noteId => text().customConstraint('NOT NULL REFERENCES note_table(id) ON DELETE CASCADE')();
  drift.IntColumn get offsetValue => integer()();
  drift.TextColumn get offsetType => textEnum<ReminderOffsetType>()();
  drift.BoolColumn get isNotification => boolean().withDefault(const drift.Constant(true))();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get updatedAt => dateTime().withDefault(drift.currentDateAndTime)();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

/// Reminder Entity Class
@freezed
abstract class ReminderEntity with _$ReminderEntity {
  const ReminderEntity._();

  @Assert('id.isNotEmpty', 'Reminder id cannot be empty')
  @Assert('scheduleId.isNotEmpty', 'Schedule id cannot be empty')
  @Assert('scheduleId != null', 'Schedule id must not be null')
  @Assert('noteId.isNotEmpty', 'Note id cannot be empty')
  @Assert('noteId != null', 'Note id must not be null')
  factory ReminderEntity({
    /// Unique identifier for the reminder (UUID)
    required String id,

    /// Identifier for the parent schedule
    required String scheduleId,

    /// Identifier for the parent note
    required String noteId,

    /// Offset value for the reminder
    required int offsetValue,

    /// Type of offset (e.g., minutes, hours, days)
    required ReminderOffsetType offsetType,

    /// Indicates if the reminder is a notification or alarm
    @Default(true) bool isNotification,

    /// Timestamp when the reminder was created
    required DateTime createdAt,

    /// Timestamp when the reminder was last updated
    required DateTime updatedAt,
  }) = _ReminderEntity;

  /// Converts the entity to a Drift companion for database operations
  ReminderTableCompanion toCompanion() {
    return ReminderTableCompanion(
      id: drift.Value(id),
      scheduleId: drift.Value(scheduleId),
      noteId: drift.Value(noteId),
      offsetValue: drift.Value(offsetValue),
      offsetType: drift.Value(offsetType),
      isNotification: drift.Value(isNotification),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
    );
  }

  factory ReminderEntity.fromJson(Map<String, dynamic> json) => _$ReminderEntityFromJson(json);

  static List<ReminderEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => ReminderEntity.fromJson(json)).toList();
  }

  /// Converts the entity to [ReminderFormElements] for form handling
  ReminderFormElements toReminderFormElements() {
    return ReminderFormElements(
      scheduleId: scheduleId,
      reminderId: id,
      noteId: noteId,
      createdAt: createdAt,
      selectedOffsetNumber: offsetValue,
      selectedOffsetType: offsetType,
      isNotification: isNotification,
    );
  }

  /// Creates a [ReminderEntity] from [ReminderFormElements] for data saving
  static ReminderEntity fromReminderFormElements(ReminderFormElements elements) {
    return ReminderEntity(
      id: elements.reminderId,
      scheduleId: elements.scheduleId,
      noteId: elements.noteId,
      offsetValue: elements.selectedOffsetNumber,
      offsetType: elements.selectedOffsetType,
      isNotification: elements.isNotification,
      createdAt: elements.createdAt ?? .now(),
      updatedAt: .now(),
    );
  }
}