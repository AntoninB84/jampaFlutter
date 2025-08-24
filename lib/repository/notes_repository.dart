import 'package:jampa_flutter/data/dao/note_dao.dart';
import 'package:jampa_flutter/data/models/note.dart';

class NotesRepository {
  const NotesRepository();


  Future<void> saveNote(NoteEntity note) async {
    await NoteDao.saveSingleNote(note);
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