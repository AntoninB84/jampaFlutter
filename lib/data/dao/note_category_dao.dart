
import 'package:jampa_flutter/data/models/note_category.dart';

import '../database.dart';

class NoteCategoryDao {
  static Future<void> saveSingleNoteCategory(NoteCategoryEntity noteCategory) async {
    final db = AppDatabase.instance();
    await db.into(db.noteCategoryTable).insert(noteCategory.toCompanion());
  }

  static Future<void> saveMultipleNoteCategories(List<NoteCategoryEntity> noteCategories) async {
    final db = AppDatabase.instance();
    await db.batch((batch) {
      for (var noteCategory in noteCategories) {
        batch.insert(db.noteCategoryTable, noteCategory.toCompanion());
      }
    });
  }

  static Future<void> cleanRelationshipsByNoteId(int noteId) async {
    final db = AppDatabase.instance();
    await (db.delete(db.noteCategoryTable)
      ..where((tbl) => tbl.noteId.equals(noteId))).go();
  }
  static Future<void> cleanRelationshipsByCategoryId(int categoryId) async {
    final db = AppDatabase.instance();
    await (db.delete(db.noteCategoryTable)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).go();
  }

  static Future<List<NoteCategoryEntity>> getNoteCategoriesByNoteId(int noteId) async {
    final db = AppDatabase.instance();
    return await (db.select(db.noteCategoryTable)
      ..where((tbl) => tbl.noteId.equals(noteId))).get();
  }

  static Future<List<NoteCategoryEntity>> getNoteCategoriesByCategoryId(int categoryId) async {
    final db = AppDatabase.instance();
    return await (db.select(db.noteCategoryTable)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  }
}