import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/models/note/note.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/category/category.dart';

/// Data Access Object (DAO) for [NoteEntity]
class NoteDao {

  /// Saves a single note to the database.
  /// If a note with the same ID already exists, it will be updated.
  /// Returns the saved [NoteEntity].
  static Future<NoteEntity> saveSingleNote(NoteEntity note) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    // Insert or update the note
    return await db.into(db.noteTable).insertReturning(
      note.toCompanion(),
      onConflict: DoUpdate((old) => note.toCompanion())
    );
  }

  /// Saves a list of notes to the database.
  /// Each note in the list will be saved individually.
  static Future<void> saveListOfNotes(List<NoteEntity> notes) async {
    await Future.forEach(notes, (noteEntity) async {
      await saveSingleNote(noteEntity);
    });
  }

  /// Updates the content of a note with the given [id] and [content].
  static Future<void> updateNoteContent(String id, String content) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.update(db.noteTable)..where((note) => note.id.equals(id)))
        .write(NoteTableCompanion(
      content: Value(content),
      updatedAt: Value(.now()),
    ));
  }

  /// Constructs a query to retrieve a note along with its related data.
  /// This includes categories and note type.
  static JoinedSelectStatement _getNoteDataQuery(AppDatabase db, String id) {
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

  /// Maps the result rows from the joined query to a [NoteEntity] with its relations.
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

  /// Retrieves a note by its [id], including its related data.
  static Future<NoteEntity?> getNoteById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    final rows = await _getNoteDataQuery(db, id).get();
    return _mapNoteWithRelations(db, rows);
  }

  /// Watches a note by its [id], including its related data.
  static Stream<NoteEntity?> watchNoteById(String id) {
    AppDatabase db = serviceLocator<AppDatabase>();
    
    return _getNoteDataQuery(db, id).watch().map((rows) {
     return _mapNoteWithRelations(db, rows);
    });
  }
  
  /// Deletes a note by its [id].
  static Future<void> deleteNoteById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteTable)..where((note) => note.id.equals(id))).go();
  }

  /// Retrieves all notes associated with the given [noteTypeId].
  static Future<List<NoteEntity>> getAllNotesByTypeId(String noteTypeId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTable)..where((note) => note.noteTypeId.equals(noteTypeId))).get();
  }

  /// Retrieves all notes associated with the given [userId].
  static Future<List<NoteEntity>> getAllNotesByUserId(String userId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTable)..where((note) => note.userId.equals(userId))).get();
  }
}