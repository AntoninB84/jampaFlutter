import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:jampa_flutter/data/models/category/category.dart' ;
import 'package:jampa_flutter/data/models/note/note.dart';
import 'package:jampa_flutter/data/models/note_type/note_type.dart';
import 'package:jampa_flutter/utils/constants/data/initial_data.dart';

import '../utils/enums/note_status_enum.dart';
import '../utils/enums/recurrence_type_enum.dart';
import '../utils/enums/reminder_offset_type_enum.dart';
import 'models/note_category/note_category.dart';
import 'models/reminder/reminder.dart';
import 'models/schedule/schedule.dart';
import 'models/user/user.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ReminderTable,
    CategoryTable,
    NoteCategoryTable,
    NoteTypeTable,
    NoteTable,
    UserTable,
    ScheduleTable
  ],
  // views: [
    // NoteListView
  // ],
  include: {'models/views/note_list_view.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static AppDatabase instance() => AppDatabase();

  /// Current schema version of the database.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Initial data can be inserted here if needed
        for(var category in InitialData.categories) {
          await into(categoryTable).insert(category.toCompanion());
        }
        for(var noteType in InitialData.noteTypes) {
          await into(noteTypeTable).insert(noteType.toCompanion());
        }
        for(var note in InitialData.notes) {
          await into(noteTable).insert(note.toCompanion());
        }
        for(var schedule in InitialData.schedules) {
          await into(scheduleTable).insert(schedule.toCompanion());
        }
        for(var alarm in InitialData.alarms) {
          await into(reminderTable).insert(alarm.toCompanion());
        }
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

  /// Opens a connection to the database.
  ///
  /// Uses a local file named 'jampa_flutter.db'.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'jampa_flutter.db',
      native: const DriftNativeOptions(),
    );
  }
}