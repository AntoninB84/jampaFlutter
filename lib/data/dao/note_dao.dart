import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/note_category.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import 'note_category_dao.dart';

class NoteDao {
  static Future<void> saveSingleNote(NoteEntity note) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    note.id = await db.into(db.noteTable).insertOnConflictUpdate(note.toCompanion());
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

  static Stream<List<NoteEntity>> watchFilteredNotes(int userId, int? noteTypeId, List<int>? categoryIds) {
    final db = serviceLocator<AppDatabase>();
    final query = db.select(db.noteTable).join([
      leftOuterJoin(
        db.noteCategoryTable,
        db.noteCategoryTable.noteId.equalsExp(db.noteTable.id),
      ),
      leftOuterJoin(
        db.categoryTable,
        db.categoryTable.id.equalsExp(db.noteCategoryTable.categoryId),
      ),
      leftOuterJoin(
        db.noteTypeTable,
        db.noteTypeTable.id.equalsExp(db.noteTable.noteTypeId)
      )
    ])
      // ..where(db.noteTable.userId.equals(userId))
      ..where(db.noteTable.noteTypeId.equalsNullable(noteTypeId));
    if(categoryIds != null && categoryIds.isNotEmpty) {
      query.where(db.noteCategoryTable.categoryId.isIn(categoryIds));
    }

    return query.watch().map((rows) {
      final noteMap = <int, NoteEntity>{};
      for (final row in rows) {
        final note = row.readTable(db.noteTable);
        final noteType = row.readTableOrNull(db.noteTypeTable);
        final category = row.readTableOrNull(db.categoryTable);

        // If the note is not already in the map,
        // add it with an empty categories list and the noteType
        if (!noteMap.containsKey(note.id)) {
          noteMap[note.id!] = note
            ..noteType = noteType
            ..categories = [];
        }
        if (category != null) {
          noteMap[note.id]!.categories!.add(category);
        }
      }
      return noteMap.values.toList();
    });
  }
  
  static Future<NoteEntity?> getNoteById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTable)..where((note) => note.id.equals(id))).getSingleOrNull();
  }
  static Future<void> deleteNoteById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteTable)..where((note) => note.id.equals(id))).go();
  }
  static Future<List<NoteEntity>> getAllNotesByTypeId(int noteTypeId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTable)..where((note) => note.noteTypeId.equals(noteTypeId))).get();
  }
  static Future<List<NoteEntity>> getAllNotesByUserId(int userId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTable)..where((note) => note.userId.equals(userId))).get();
  }
}