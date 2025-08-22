import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/category.dart' ;
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:path_provider/path_provider.dart';

import 'models/note_category.dart';
import 'models/user.dart';
import 'models/views/note_list_view.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    CategoryTable,
    NoteCategoryTable,
    NoteTypeTable,
    NoteTable,
    UserTable,
  ],
  // views: [
    // NoteListView
  // ],
  include: {'models/views/note_list_view.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static AppDatabase instance() => AppDatabase();

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Initial data can be inserted here if needed
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Handle migration from version 1 to 2
          //e.g m.create(...), m.addColumn(...), etc.
        }
      },
      beforeOpen: (details) async {
        if (kDebugMode) {
          print(details);
        };
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'jampa_flutter.db',
      native: const DriftNativeOptions(),
    );
  }
}