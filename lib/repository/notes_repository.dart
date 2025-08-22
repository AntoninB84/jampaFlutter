import 'package:jampa_flutter/data/dao/note_dao.dart';
import 'package:jampa_flutter/data/models/note.dart';

class NotesRepository {
  const NotesRepository();

  Stream<List<NoteEntity>> watchNotesWithFilters(int userId, int? noteTypeId, List<int>? categoryIds) {
    return NoteDao.watchFilteredNotes(userId, noteTypeId, categoryIds);
  }

  Future<void> saveNote(NoteEntity note) async {
    await NoteDao.saveSingleNote(note);
  }

  Future<void> saveNotes(List<NoteEntity> notes) async {
    await NoteDao.saveListOfNotes(notes);
  }

  Future<void> deleteNoteById(int id) async {
    await NoteDao.deleteNoteById(id);
  }

  Future<NoteEntity?> getNoteById(int id) async {
    return await NoteDao.getNoteById(id);
  }
}