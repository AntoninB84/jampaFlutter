
import 'package:jampa_flutter/data/dao/note_type_dao.dart';
import 'package:jampa_flutter/data/models/note_type.dart';

/// Repository for managing note types.
class NoteTypesRepository {
  const NoteTypesRepository();

  /// Retrieves all note types.
  Future<List<NoteTypeEntity>> getNoteTypes() async {
      return await NoteTypeDao.getAllNoteTypes();
  }

  /// Watches all note types.
  Stream<List<NoteTypeEntity>> watchAllNotesTypes() {
    return NoteTypeDao.watchAllNoteTypes();
  }

  /// Watches all note types with their associated note counts.
  Stream<List<NoteTypeWithCount>> watchAllNotesTypesWithCount() {
    return NoteTypeDao.watchAllNoteTypesWithCount();
  }

  /// Retrieves a note type by its ID.
  Future<NoteTypeEntity?> getNoteTypeById(String id) async {
    return await NoteTypeDao.getNoteTypeById(id);
  }

  /// Retrieves a note type by its name.
  Future<NoteTypeEntity?> getNoteTypeByName(String name) async {
    return await NoteTypeDao.getNoteTypeByName(name);
  }

  /// Saves a note type.
  Future<void> saveNoteType(NoteTypeEntity noteType) async {
    await NoteTypeDao.saveSingleNoteType(noteType);
  }

  /// Deletes a note type by its ID.
  Future<void> deleteNoteType(String id) async {
    await NoteTypeDao.deleteNoteTypeById(id);
  }
}