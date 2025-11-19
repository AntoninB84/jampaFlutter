
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note.dart';

import '../database.dart';

@UseRowClass(NoteCategoryEntity)
class NoteCategoryTable extends Table {
  TextColumn get noteId => text().references(NoteTable, #id)();
  IntColumn get categoryId => integer().references(CategoryTable, #id)();
}

class NoteCategoryEntity {
  final String noteId;
  final int categoryId;

  NoteCategoryEntity({
    required this.noteId,
    required this.categoryId,
  });

  @override
  String toString() {
    return 'NoteCategoryEntity{noteId: $noteId, categoryId: $categoryId}';
  }

  NoteCategoryTableCompanion toCompanion() {
    return NoteCategoryTableCompanion(
      noteId: Value(noteId),
      categoryId: Value(categoryId),
    );
  }

  NoteCategoryEntity.fromJson(Map<String, dynamic> json)
      : noteId = json['noteId'] as String,
        categoryId = json['categoryId'] as int;
}