import 'package:jampa_flutter/data/dao/note_dao.dart';
import 'package:jampa_flutter/data/models/note.dart';

import '../data/dao/note_category_dao.dart';
import '../data/models/category.dart';
import '../data/models/note_category.dart';

class NotesRepository {
  const NotesRepository();


  Future<void> saveNote(NoteEntity note) async {
    bool isUpdate = note.id != null;
    
    await NoteDao.saveSingleNote(note).then((insertedNote) async {
      // Re-assign categories to the inserted note
      insertedNote.categories = note.categories;
      if(isUpdate){
        // Clean existing relationships for the note
        await NoteCategoryDao.cleanRelationshipsByNoteId(insertedNote.id!);
      }
      // Then, re-establish relationships
      if(insertedNote.categories?.isNotEmpty ?? false) {
        List<NoteCategoryEntity> noteCategories = insertedNote.categories!.map((category) {
          return NoteCategoryEntity(
            noteId: insertedNote.id!,
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

  Future<void> deleteNoteById(int id) async {
    await NoteDao.deleteNoteById(id);
  }

  Stream<NoteEntity?> watchNoteById(int id)  {
    return NoteDao.watchNoteById(id);
  }
  Future<NoteEntity?> getNoteById(int id) async {
    return await NoteDao.getNoteById(id);
  }
}