
import 'package:jampa_flutter/data/dao/note_type_dao.dart';
import 'package:jampa_flutter/data/models/note_type/note_type.dart';
import 'package:jampa_flutter/utils/storage/sync_storage_service.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../data/objects/note_type_with_count.dart';

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
    // Track deletion for sync
    try {
      final syncStorage = serviceLocator<SyncStorageService>();
      await syncStorage.addPendingDeletion('note_type', id);
    } catch (e) {
      // If sync storage is not available, continue without tracking
      print('Failed to track deletion for sync: $e');
    }
  }
}