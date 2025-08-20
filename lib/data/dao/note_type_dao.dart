
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/note_type.dart';

class NoteTypeDao {

  static Future<void> saveSingleNoteType(NoteTypeEntity noteType) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db
        .into(db.noteTypeTable)
        .insertOnConflictUpdate(noteType.toCompanion());
  }

  static Future<void> saveListOfNoteTypes(List<NoteTypeEntity> noteTypes) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.noteTypeTable,
        noteTypes.map((noteType) => noteType.toCompanion()).toList(),
      );
    });
  }

  static Future<List<NoteTypeEntity>> getAllNoteTypes() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.select(db.noteTypeTable).get();
  }
  static Future<NoteTypeEntity?> getNoteTypeById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTypeTable)..where((noteType) => noteType.id.equals(id))).getSingleOrNull();
  }
  static Future<void> deleteNoteTypeById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteTypeTable)..where((noteType) => noteType.id.equals(id))).go();
  }

}