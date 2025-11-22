
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

class NoteListViewDao {

  static Stream<List<NoteListViewData>> watchAllNotesWithFilters(String? noteTypeId, List<String>? categoryIds) {
    final db = serviceLocator<AppDatabase>();
    final query = db.select(db.noteListView)
      ..where((tbl) => tbl.noteId.isNotNull());

    if(noteTypeId != null){
      query.where((tbl) => tbl.noteTypeId.equalsNullable(noteTypeId));
    }

    if(categoryIds != null && categoryIds.isNotEmpty) {
      for (final id in categoryIds) {
        query.where((tbl) => tbl.categoriesIds.like('%,$id,%'));
      }
    }

    query.orderBy([
      (tbl) => OrderingTerm(expression: tbl.noteUpdatedAt, mode: OrderingMode.desc)
    ]);

    return query.watch();
  }

}