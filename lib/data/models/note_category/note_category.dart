
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jampa_flutter/data/models/category/category.dart';
import 'package:jampa_flutter/data/models/note/note.dart';

import '../../database.dart';

part 'note_category.freezed.dart';
part 'note_category.g.dart';

/// Junction table for many-to-many relationship between notes and categories
@drift.UseRowClass(NoteCategoryEntity)
class NoteCategoryTable extends drift.Table {
  drift.TextColumn get noteId => text().references(NoteTable, #id)();
  drift.TextColumn get categoryId => text().references(CategoryTable, #id)();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();

  @override
  Set<drift.Column<Object>> get primaryKey => {noteId, categoryId};
}

/// Entity class representing the relationship between a note and a category
@freezed
abstract class NoteCategoryEntity with _$NoteCategoryEntity {
  const NoteCategoryEntity._();

  @Assert('noteId.isNotEmpty', 'Note ID cannot be empty')
  @Assert('categoryId.isNotEmpty', 'Category ID cannot be empty')
  factory NoteCategoryEntity({
    /// The ID of the note
    required String noteId,
    /// The ID of the category
    required String categoryId,
    /// Timestamp when the relationship was created
    required DateTime createdAt,
  }) = _NoteCategoryEntity;

  /// Converts the entity to a companion object for database operations
  NoteCategoryTableCompanion toCompanion() {
    return NoteCategoryTableCompanion(
      noteId: drift.Value(noteId),
      categoryId: drift.Value(categoryId),
      createdAt: drift.Value(createdAt),
    );
  }

  factory NoteCategoryEntity.fromJson(Map<String, dynamic> json) => _$NoteCategoryEntityFromJson(json);
}