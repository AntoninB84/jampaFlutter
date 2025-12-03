
import 'package:drift/drift.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/note_type/note_type.dart';
import '../objects/note_type_with_count.dart';

/// Data Access Object (DAO) for [NoteTypeEntity]
class NoteTypeDao {

  /// Saves a single [NoteTypeEntity] to the database.
  static Future<void> saveSingleNoteType(NoteTypeEntity noteType) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db
        .into(db.noteTypeTable)
        .insertOnConflictUpdate(noteType.toCompanion());
  }

  /// Saves a list of [NoteTypeEntity] to the database in a batch operation.
  static Future<void> saveListOfNoteTypes(List<NoteTypeEntity> noteTypes) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.noteTypeTable,
        noteTypes.map((noteType) => noteType.toCompanion()).toList(),
      );
    });
  }

  /// Retrieves all [NoteTypeEntity] from the database, ordered by name.
  static Future<List<NoteTypeEntity>> getAllNoteTypes() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTypeTable)..orderBy([(t) => OrderingTerm(expression: t.name)])).get();
  }

  /// Watches all [NoteTypeEntity] from the database, ordered by name.
  static Stream<List<NoteTypeEntity>> watchAllNoteTypes() {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.noteTypeTable)..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();
  }

  /// Watches all [NoteTypeEntity] along with the count of associated notes.
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

  /// Retrieves a single [NoteTypeEntity] by its ID.
  static Future<NoteTypeEntity?> getNoteTypeById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTypeTable)..where((noteType) => noteType.id.equals(id))).getSingleOrNull();
  }

  /// Retrieves a single [NoteTypeEntity] by its name.
  static Future<NoteTypeEntity?> getNoteTypeByName(String name) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.noteTypeTable)..where((noteType) => noteType.name.equals(name))).getSingleOrNull();
  }

  /// Deletes a [NoteTypeEntity] by its ID.
  static Future<void> deleteNoteTypeById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.noteTypeTable)..where((noteType) => noteType.id.equals(id))).go();
  }

}