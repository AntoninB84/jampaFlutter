import 'package:jampa_flutter/data/dao/note_dao.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../data/dao/note_category_dao.dart';
import '../data/models/note_category.dart';

class NotesRepository {
  const NotesRepository();


  Future<NoteEntity> saveNote(NoteEntity note) async {
    return await NoteDao.saveSingleNote(note).then((insertedNote) async {
      // Re-assign categories to the inserted note
      insertedNote.categories = note.categories;
      // Clean existing relationships for the note
      await NoteCategoryDao.cleanRelationshipsByNoteId(insertedNote.id);
      // Then, re-establish relationships
      if(insertedNote.categories?.isNotEmpty ?? false) {
        List<NoteCategoryEntity> noteCategories = insertedNote.categories!.map((category) {
          return NoteCategoryEntity(
            noteId: insertedNote.id,
            categoryId: category.id!,
          );
        }).toList();
        await NoteCategoryDao.saveMultipleNoteCategories(noteCategories);
      }
      return insertedNote;
    });
    
  }

  Future<void> saveNotes(List<NoteEntity> notes) async {
    await NoteDao.saveListOfNotes(notes);
  }

  Future<void> updateNoteContent(String id, String content) async {
    await NoteDao.updateNoteContent(id, content);
  }

  Future<void> deleteNoteById(String id) async {
    await serviceLocator<ScheduleRepository>().deleteSchedulesByNoteId(id);
    await NoteDao.deleteNoteById(id);
  }

  Stream<NoteEntity?> watchNoteById(String id)  {
    return NoteDao.watchNoteById(id);
  }
  Future<NoteEntity?> getNoteById(String id) async {
    return await NoteDao.getNoteById(id);
  }
}