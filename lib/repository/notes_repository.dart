import 'package:jampa_flutter/data/dao/note_dao.dart';
import 'package:jampa_flutter/data/models/note/note.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:jampa_flutter/utils/storage/sync_storage_service.dart';

import '../data/dao/note_category_dao.dart';
import '../data/models/note_category/note_category.dart';

/// Repository for managing notes and their related operations.
class NotesRepository {
  const NotesRepository();

  /// Saves a single note and manages its category relationships.
  /// Returns the saved [NoteEntity].
  Future<NoteEntity> saveNote(NoteEntity note) async {
    return await NoteDao.saveSingleNote(note).then((insertedNote) async {
      // Re-assign categories to the inserted note
      insertedNote = insertedNote.copyWith(categories: note.categories);
      // Clean existing relationships for the note
      await NoteCategoryDao.cleanRelationshipsByNoteId(insertedNote.id);
      // Then, re-establish relationships
      if(insertedNote.categories?.isNotEmpty ?? false) {
        final now = DateTime.now();
        List<NoteCategoryEntity> noteCategories = insertedNote.categories!.map((category) {
          return NoteCategoryEntity(
            noteId: insertedNote.id,
            categoryId: category.id,
            createdAt: now,
          );
        }).toList();
        await NoteCategoryDao.saveMultipleNoteCategories(noteCategories);
      }
      return insertedNote;
    });
  }

  /// Saves a list of notes to the database.
  Future<void> saveNotes(List<NoteEntity> notes) async {
    await NoteDao.saveListOfNotes(notes);
  }

  /// Updates the content of a note with the given [id] and [content].
  Future<void> updateNoteContent(String id, String content) async {
    await NoteDao.updateNoteContent(id, content);
  }

  /// Deletes a note by its [id] and also removes associated schedules.
  Future<void> deleteNoteById(String id) async {
    await serviceLocator<ScheduleRepository>().deleteSchedulesByNoteId(id);
    await NoteDao.deleteNoteById(id);
    // Track deletion for sync
    try {
      final syncStorage = serviceLocator<SyncStorageService>();
      await syncStorage.addPendingDeletion('note', id);
    } catch (e) {
      // If sync storage is not available, continue without tracking
      print('Failed to track deletion for sync: $e');
    }
  }

  /// Watches a note by its [id] and returns a stream of [NoteEntity].
  Stream<NoteEntity?> watchNoteById(String id)  {
    return NoteDao.watchNoteById(id);
  }

  /// Retrieves a note by its [id].
  Future<NoteEntity?> getNoteById(String id) async {
    return await NoteDao.getNoteById(id);
  }
}