
import 'package:jampa_flutter/data/dao/note_type_dao.dart';
import 'package:jampa_flutter/data/models/note_type.dart';

class NoteTypesRepository {
  const NoteTypesRepository();

  Future<List<NoteTypeEntity>> getNoteTypes() async {
      return await NoteTypeDao.getAllNoteTypes();
  }
  Stream<List<NoteTypeEntity>> getNoteTypesStream() {
    return NoteTypeDao.getAllNoteTypesStream();
  }

  Future<NoteTypeEntity?> getNoteTypeById(int id) async {
    return await NoteTypeDao.getNoteTypeById(id);
  }

  Future<NoteTypeEntity?> getNoteTypeByName(String name) async {
    return await NoteTypeDao.getNoteTypeByName(name);
  }

  Future<void> saveNoteType(NoteTypeEntity noteType) async {
    await NoteTypeDao.saveSingleNoteType(noteType);
  }

  Future<void> deleteNoteType(int id) async {
    await NoteTypeDao.deleteNoteTypeById(id);
  }
}