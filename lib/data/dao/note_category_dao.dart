
import 'package:jampa_flutter/data/models/note_category/note_category.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';

/// Data Access Object (DAO) for [NoteCategoryEntity]
class NoteCategoryDao {

  /// Saves a single note-category relationship to the database.
  static Future<void> saveSingleNoteCategory(NoteCategoryEntity noteCategory) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.into(db.noteCategoryTable).insert(noteCategory.toCompanion());
  }

  /// Saves multiple note-category relationships to the database in a batch operation.
  static Future<void> saveMultipleNoteCategories(List<NoteCategoryEntity> noteCategories) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      for (var noteCategory in noteCategories) {
        batch.insert(db.noteCategoryTable, noteCategory.toCompanion());
      }
    });
  }

  /// Cleans up all note-category relationships for a specific note ID.
  static Future<void> cleanRelationshipsByNoteId(String noteId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteCategoryTable)
      ..where((tbl) => tbl.noteId.equals(noteId))).go();
  }

  /// Cleans up all note-category relationships for a specific category ID.
  static Future<void> cleanRelationshipsByCategoryId(String categoryId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteCategoryTable)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).go();
  }

  /// Retrieves all note-category relationships for a specific note ID.
  static Future<List<NoteCategoryEntity>> getNoteCategoriesByNoteId(String noteId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteCategoryTable)
      ..where((tbl) => tbl.noteId.equals(noteId))).get();
  }

  /// Retrieves all note-category relationships for a specific category ID.
  static Future<List<NoteCategoryEntity>> getNoteCategoriesByCategoryId(String categoryId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteCategoryTable)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  }
}