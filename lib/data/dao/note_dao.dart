import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/note_category.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/category.dart';
import 'note_category_dao.dart';

class NoteDao {
  static Future<void> saveSingleNote(NoteEntity note) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    // Extract categories before inserting the note
    List<CategoryEntity> categories = note.categories ?? [];
    // Insert or update the note
    note = await db.into(db.noteTable).insertReturning(
      note.toCompanion(),
      onConflict: DoUpdate((old) => note.toCompanion())
    );
    // Clean existing relationships for the note
    await NoteCategoryDao.cleanRelationshipsByNoteId(note.id!);
    // Then, re-establish relationships
    if(categories.isNotEmpty) {
      List<NoteCategoryEntity> noteCategories = categories.map((category) {
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

  static JoinedSelectStatement _getNoteDataQuery(AppDatabase db, int id) {
    return (db.select(db.noteTable)
      ..where((note) => note.id.equals(id)))
      .join([
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
          db.noteTypeTable.id.equalsExp(db.noteTable.noteTypeId),
        ),
      ]);
  }

  static NoteEntity? _mapNoteWithRelations(AppDatabase db, rows) {
    if(rows.isEmpty) return null;
    final note = rows.first.readTable(db.noteTable);
    final noteType = rows.first.readTableOrNull(db.noteTypeTable);
    final categories = rows
        .map((row) => row?.readTableOrNull(db.categoryTable))
        .where((cat) => cat != null && cat.id != null)
        .cast<CategoryEntity>()
        .toList();

    return NoteEntity(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      userId: note.userId,
      noteTypeId: note.noteTypeId,
      noteType: noteType,
      categories: categories,
    );
  }

  static Future<NoteEntity?> getNoteById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    final rows = await _getNoteDataQuery(db, id).get();
    return _mapNoteWithRelations(db, rows);
  }


  static Stream<NoteEntity?> watchNoteById(int id) {
    AppDatabase db = serviceLocator<AppDatabase>();
    
    return _getNoteDataQuery(db, id).watch().map((rows) {
     return _mapNoteWithRelations(db, rows);
    });
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