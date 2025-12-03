import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/category/category.dart';
import 'package:jampa_flutter/data/models/note_type/note_type.dart';
import 'package:jampa_flutter/data/models/user/user.dart';
import 'package:jampa_flutter/utils/enums/note_status_enum.dart';
import 'package:jampa_flutter/utils/constants/constants.dart';

part 'note.freezed.dart';
part 'note.g.dart';

/// Drift table definition for notes
@drift.UseRowClass(NoteEntity)
class NoteTable extends drift.Table {
  drift.TextColumn get id => text()();
  drift.TextColumn get title => text().withLength(min: 1, max: 100)();
  drift.TextColumn get content => text().nullable()();
  drift.BoolColumn get isImportant => boolean().withDefault(const drift.Constant(false))();
  drift.TextColumn get status => textEnum<NoteStatusEnum>().withDefault(drift.Constant(NoteStatusEnum.todo.name))();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get updatedAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.TextColumn get noteTypeId => text().references(NoteTypeTable, #id).nullable()();
  drift.TextColumn get userId => text().references(UserTable, #id).nullable()();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

/// Entity class representing a note
@Freezed(makeCollectionsUnmodifiable: false)
abstract class NoteEntity with _$NoteEntity {
  const NoteEntity._();

  @Assert('id.isNotEmpty', 'Note id cannot be empty')
  @Assert('title.length >= $kEntityNameMinLength', 'Note title must be at least $kEntityNameMinLength character long')
  @Assert('title.length <= $kEntityNameMaxLength', 'Note title cannot exceed $kEntityNameMaxLength characters')
  const factory NoteEntity({
    /// Unique identifier for the note (UUID)
    required String id,

    /// Title of the note
    required String title,

    /// Content of the note (optional).
    /// JSON content currently used with Quill editor
    String? content,

    /// Flag indicating if the note is marked as important (not in use atm)
    @Default(false) bool isImportant,

    /// Status of the note (e.g., to do, done)
    @Default(NoteStatusEnum.todo) NoteStatusEnum status,

    /// Timestamp when the note was created
    required DateTime createdAt,

    /// Timestamp when the note was last updated
    required DateTime updatedAt,

    /// Identifier for the type of the note (optional UUID)
    String? noteTypeId,

    /// The type of the note (optional)
    NoteTypeEntity? noteType,

    /// Identifier for the user who owns the note (UUID). Not yet in use
    String? userId,

    /// List of categories associated with the note (optional)
    List<CategoryEntity>? categories,
  }) = _NoteEntity;


  /// Converts the NoteEntity instance to a NoteTableCompanion for database operations
  NoteTableCompanion toCompanion() {
    return NoteTableCompanion(
      id: drift.Value(id),
      title: drift.Value(title),
      content: content == null ? .absent() : drift.Value(content!),
      isImportant: drift.Value(isImportant),
      status: drift.Value(status),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
      noteTypeId: noteTypeId == null ? .absent() : drift.Value(noteTypeId!),
      userId: drift.Value(userId),
    );
  }

  factory NoteEntity.fromJson(Map<String, dynamic> json) => _$NoteEntityFromJson(json);

  static Future<List<NoteEntity>> fromJsonArray(List jsonArray) async {
    return jsonArray.map((json) => NoteEntity.fromJson(json)).toList();
  }
}