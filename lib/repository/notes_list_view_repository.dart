
import 'package:jampa_flutter/data/dao/note_list_view_dao.dart';
import 'package:jampa_flutter/data/database.dart';

class NotesListViewRepository {
  const NotesListViewRepository();

  Stream<List<NoteListViewData>> watchNotesWithFilters(String? noteTypeId, List<String>? categoryIds) {
    return NoteListViewDao.watchAllNotesWithFilters(noteTypeId, categoryIds);
  }
}