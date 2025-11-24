
import 'package:jampa_flutter/data/dao/note_list_view_dao.dart';
import 'package:jampa_flutter/data/database.dart';

/// Repository for accessing notes in list view with optional filters.
class NotesListViewRepository {
  const NotesListViewRepository();

  /// Watches notes with optional filters for note type and categories.
  /// The list is ordered by updated date descending.
  ///
  /// [noteTypeId] - Optional filter for note type ID.
  ///
  /// [categoryIds] - Optional list of category IDs to filter notes.
  Stream<List<NoteListViewData>> watchNotesWithFilters(String? noteTypeId, List<String>? categoryIds) {
    return NoteListViewDao.watchAllNotesWithFilters(noteTypeId, categoryIds);
  }
}