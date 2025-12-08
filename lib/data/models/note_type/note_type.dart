
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jampa_flutter/utils/constants/constants.dart';

import '../../database.dart';

part 'note_type.freezed.dart';
part 'note_type.g.dart';

/// The Drift table definition for note types.
@drift.UseRowClass(NoteTypeEntity)
class NoteTypeTable extends drift.Table {
  drift.TextColumn get id => text()();
  drift.TextColumn get name => text().withLength(min: 1, max: 100)();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get updatedAt => dateTime().withDefault(drift.currentDateAndTime)();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

/// The entity class representing a note type.
@freezed
abstract class NoteTypeEntity with _$NoteTypeEntity {
  const NoteTypeEntity._();

  @Assert('id.isNotEmpty', 'Note type id cannot be empty')
  @Assert('name.length >= $kEntityNameMinLength', 'Note type name must be at least $kEntityNameMinLength character long')
  @Assert('name.length <= $kEntityNameMaxLength', 'Note type name cannot exceed $kEntityNameMaxLength characters')
  factory NoteTypeEntity({
    /// The unique identifier for the note type (UUID).
    required String id,

    /// The name of the note type.
    required String name,

    /// The timestamp when the note type was created.
    required DateTime createdAt,

    /// The timestamp when the note type was last updated.
    required DateTime updatedAt,
  }) = _NoteTypeEntity;

  /// Converts this entity to a NoteTypeTableCompanion for database operations.
  NoteTypeTableCompanion toCompanion() {
    return NoteTypeTableCompanion(
      id: drift.Value(id),
      name: drift.Value(name),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
    );
  }

  factory NoteTypeEntity.fromJson(Map<String, dynamic> json) => _$NoteTypeEntityFromJson(json);

  static List<NoteTypeEntity> fromJsonArray(List jsonArray) {
    return jsonArray.map((json) => NoteTypeEntity.fromJson(json)).toList();
  }
}