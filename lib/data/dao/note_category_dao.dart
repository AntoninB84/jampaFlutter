
import 'package:jampa_flutter/data/models/note_category.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';

class NoteCategoryDao {
  static Future<void> saveSingleNoteCategory(NoteCategoryEntity noteCategory) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.into(db.noteCategoryTable).insert(noteCategory.toCompanion());
  }

  static Future<void> saveMultipleNoteCategories(List<NoteCategoryEntity> noteCategories) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      for (var noteCategory in noteCategories) {
        batch.insert(db.noteCategoryTable, noteCategory.toCompanion());
      }
    });
  }

  static Future<void> cleanRelationshipsByNoteId(String noteId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteCategoryTable)
      ..where((tbl) => tbl.noteId.equals(noteId))).go();
  }
  static Future<void> cleanRelationshipsByCategoryId(int categoryId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteCategoryTable)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).go();
  }

  static Future<List<NoteCategoryEntity>> getNoteCategoriesByNoteId(String noteId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteCategoryTable)
      ..where((tbl) => tbl.noteId.equals(noteId))).get();
  }

  static Future<List<NoteCategoryEntity>> getNoteCategoriesByCategoryId(int categoryId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteCategoryTable)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  }
}