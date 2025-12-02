
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/utils/enums/note_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

/// Data Access Object (DAO) for [note_list_view] table.
class NoteListViewDao {

  /// Watches all notes with optional filters for note type and categories,
  /// ordered by updated date descending.
  ///
  /// [noteTypeId] - Optional filter for note type ID.
  ///
  /// [categoryIds] - Optional list of category IDs to filter notes.
  static Stream<List<NoteListViewData>> watchAllNotesWithFilters(
      {
        String? noteTypeId,
        List<String>? categoryIds,
        List<NoteStatusEnum>? statuses,
      }) {

    final db = serviceLocator<AppDatabase>();
    final query = db.select(db.noteListView)
      ..where((tbl) => tbl.noteId.isNotNull());

    // Apply note type filter if provided
    if(noteTypeId != null){
      query.where((tbl) => tbl.noteTypeId.equalsNullable(noteTypeId));
    }

    // Apply category filters if provided
    if(categoryIds != null && categoryIds.isNotEmpty) {
      for (final id in categoryIds) {
        query.where((tbl) => tbl.categoriesIds.like('%,$id,%'));
      }
    }

    // Apply status filter if provided
    if(statuses != null && statuses.isNotEmpty){
      final statusValues = statuses.map((e) => e.name).toList();
      query.where((tbl) => tbl.noteStatus.isIn(statusValues));
    }

    // Order by note updated at in descending order
    query.orderBy([
      (tbl) => OrderingTerm(expression: tbl.noteUpdatedAt, mode: .desc)
    ]);

    return query.watch();
  }

}