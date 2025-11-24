
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note.dart';

import '../database.dart';

/// Junction table for many-to-many relationship between notes and categories
@UseRowClass(NoteCategoryEntity)
class NoteCategoryTable extends Table {
  TextColumn get noteId => text().references(NoteTable, #id)();
  TextColumn get categoryId => text().references(CategoryTable, #id)();
}

/// Entity class representing the relationship between a note and a category
class NoteCategoryEntity {

  /// The ID of the note
  final String noteId;
  /// The ID of the category
  final String categoryId;

  NoteCategoryEntity({
    required this.noteId,
    required this.categoryId,
  });

  @override
  String toString() {
    return 'NoteCategoryEntity{noteId: $noteId, categoryId: $categoryId}';
  }

  /// Converts the entity to a companion object for database operations
  NoteCategoryTableCompanion toCompanion() {
    return NoteCategoryTableCompanion(
      noteId: Value(noteId),
      categoryId: Value(categoryId),
    );
  }

  NoteCategoryEntity.fromJson(Map<String, dynamic> json)
      : noteId = json['noteId'] as String,
        categoryId = json['categoryId'] as String;
}