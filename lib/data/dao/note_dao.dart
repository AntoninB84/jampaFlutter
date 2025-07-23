import 'package:jampa_flutter/data/dao/category_dao.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/note_category.dart';

import '../database.dart';
import '../models/category.dart';
import 'note_category_dao.dart';

class NoteDao {
  static Future<void> saveSingleNote(NoteEntity note) async {
    AppDatabase db = AppDatabase.instance();
    await db.into(db.noteTable).insertOnConflictUpdate(note.toCompanion());
    await NoteCategoryDao.cleanRelationshipsByNoteId(note.id!);
    // If the note has categories, save the relationships
    if(note.categories != null && note.categories!.isNotEmpty) {
      List<NoteCategoryEntity> noteCategories = note.categories!.map((category) {
        return NoteCategoryEntity(
          noteId: note.id!,
          categoryId: category.id!,
        );
      }).toList();
      await NoteCategoryDao.saveMultipleNoteCategories(noteCategories);
    }
  }

  static Future<void> saveListOfNotes(List<NoteEntity> notes) async {
    await Future.forEach(notes, (noteEntity) async {
      await saveSingleNote(noteEntity);
    });
  }
  
  static Future<List<NoteEntity>> getAllNotes() async {
    AppDatabase db = AppDatabase.instance();
    List<NoteEntity> noteEntities =  await db.select(db.noteTable).get();
    await Future.forEach(noteEntities, (noteEntity) async {
      // Fetch categories for each note
      List<NoteCategoryEntity> noteCategories = await NoteCategoryDao.getNoteCategoriesByNoteId(noteEntity.id!);
      List<CategoryEntity> categories = [];
      await Future.forEach(noteCategories, (noteCategory) async {
        CategoryEntity? category = await CategoryDao.getCategoryById(noteCategory.categoryId);
        if (category != null) {
          categories.add(category);
        }
      });
      noteEntity.categories = categories;
    });
    return noteEntities;
  }
  
  static Future<NoteEntity?> getNoteById(int id) async {
    AppDatabase db = AppDatabase.instance();
    return await (db.select(db.noteTable)..where((note) => note.id.equals(id))).getSingleOrNull();
  }
  static Future<void> deleteNoteById(int id) async {
    AppDatabase db = AppDatabase.instance();
    await (db.delete(db.noteTable)..where((note) => note.id.equals(id))).go();
  }
  static Future<List<NoteEntity>> getAllNotesByTypeId(int noteTypeId) async {
    AppDatabase db = AppDatabase.instance();
    return await (db.select(db.noteTable)..where((note) => note.noteTypeId.equals(noteTypeId))).get();
  }
  static Future<List<NoteEntity>> getAllNotesByUserId(int userId) async {
    AppDatabase db = AppDatabase.instance();
    return await (db.select(db.noteTable)..where((note) => note.userId.equals(userId))).get();
  }
}