
import 'package:drift/drift.dart';
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
    return await (db.select(db.noteTypeTable)..orderBy([(t) => OrderingTerm(expression: t.name)])).get();
  }

  static Stream<List<NoteTypeEntity>> watchAllNoteTypes() {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.noteTypeTable)..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
  }
  static Stream<List<NoteTypeWithCount>> watchAllNoteTypesWithCount() {
    AppDatabase db = serviceLocator<AppDatabase>();
    final noteTypeAlias = db.alias(db.noteTypeTable, 'nt');
    final noteAlias = db.alias(db.noteTable, 'n');

    final query = (db.select(noteTypeAlias)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .join([
        leftOuterJoin(
          noteAlias,
          noteAlias.noteTypeId.equalsExp(noteTypeAlias.id),
        ),
      ])
      ..addColumns([noteAlias.id.count()])
      ..groupBy([noteTypeAlias.id]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final noteType = row.readTable(noteTypeAlias);
        final count = row.read(noteAlias.id.count());
        return NoteTypeWithCount(noteType: noteType, noteCount: count ?? 0);
      }).toList();
    });
  }

  static Future<NoteTypeEntity?> getNoteTypeById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTypeTable)..where((noteType) => noteType.id.equals(id))).getSingleOrNull();
  }
  static Future<NoteTypeEntity?> getNoteTypeByName(String name) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTypeTable)..where((noteType) => noteType.name.equals(name))).getSingleOrNull();
  }

  static Future<void> deleteNoteTypeById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteTypeTable)..where((noteType) => noteType.id.equals(id))).go();
  }

}