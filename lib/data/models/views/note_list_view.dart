// import 'package:drift/drift.dart';
// import 'package:jampa_flutter/data/models/category.dart';
// import 'package:jampa_flutter/data/models/note.dart';
// import 'package:jampa_flutter/data/models/note_category.dart';
// import 'package:jampa_flutter/data/models/note_type.dart';
//
// abstract class NoteListView extends View {
//
//   NoteTable get noteTable;
//   CategoryTable get categoryTable;
//   NoteCategoryTable get noteCategoryTable;
//   NoteTypeTable get noteTypeTable;
//
//   Expression<int> get noteId => noteTable.id;
//   Expression<String> get noteTitle => noteTable.title;
//   Expression<DateTime> get noteCreatedAt => noteTable.createdAt;
//   Expression<int> get noteTypeId => noteTable.noteTypeId;
//   Expression<String> get noteTypeName => noteTypeTable.name;
//   Expression<String> get categoriesIds => categoryTable.id.groupConcat();
//   Expression<String> get categoriesNames => categoryTable.name.groupConcat();
//
//   @override
//   Query as() => select([
//         noteId,
//         noteTitle,
//         noteCreatedAt,
//         noteTypeId,
//         noteTypeName,
//         // categoriesIds,
//         // categoriesNames,
//       ])
//       .from(noteTable)
//       .join([
//         leftOuterJoin(
//           noteTypeTable,
//           noteTypeTable.id.equalsExp(noteTable.noteTypeId),
//         ),
//         leftOuterJoin(
//           noteCategoryTable,
//           noteCategoryTable.noteId.equalsExp(noteTable.id),
//         ),
//         leftOuterJoin(
//           categoryTable,
//           categoryTable.id.equalsExp(noteCategoryTable.categoryId),
//         ),
//       ]);
//
// }
