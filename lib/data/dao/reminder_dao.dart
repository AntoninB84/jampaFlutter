
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/reminder/reminder.dart';

import '../../utils/service_locator.dart';

/// Data Access Object (DAO) for [ReminderEntity]
class ReminderDao {

  /// Saves a single reminder to the database.
  /// If a reminder with the same ID already exists, it will be updated.
  /// Returns the saved or updated [ReminderEntity].
  static Future<ReminderEntity> saveSingleReminder(ReminderEntity reminder) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.into(db.reminderTable).insertReturning(
      reminder.toCompanion(),
      onConflict: DoUpdate((old) => reminder.toCompanion())
    );
  }

  /// Saves a list of reminders to the database, updating existing ones if necessary.
  static Future<void> saveListOfReminders(List<ReminderEntity> reminders) async {
    await Future.forEach(reminders, (reminderEntity) async {
      await saveSingleReminder(reminderEntity);
    });
  }

  /// Watches a single reminder by its ID.
  static Stream<ReminderEntity?> watchReminderById(String id)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.reminderTable)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Retrieves a single reminder by its ID.
  static Future<ReminderEntity?> getReminderById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.reminderTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watches all reminders in the database.
  static Stream<List<ReminderEntity>> watchAllReminders()  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.reminderTable))
        .watch();
  }

  /// Retrieves all reminders from the database.
  static Future<List<ReminderEntity>> getAllReminders() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.reminderTable))
        .get();
  }

  /// Watches all reminders associated with a specific schedule ID.
  static Stream<List<ReminderEntity>> watchAllRemindersByScheduleId(String scheduleId)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.reminderTable)..where((tbl) => tbl.scheduleId.equals(scheduleId)))
        .watch();
  }

  /// Retrieves all reminders associated with a specific schedule ID.
  static Future<List<ReminderEntity>> getAllRemindersByScheduleId(String scheduleId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.reminderTable)..where((tbl) => tbl.scheduleId.equals(scheduleId)))
        .get();
  }

  /// Deletes a reminder by its ID.
  static Future<void> deleteReminderById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.reminderTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Deletes all reminders associated with a specific schedule ID.
  static Future<void> deleteRemindersByScheduleId(String scheduleId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.reminderTable)..where((tbl) => tbl.scheduleId.equals(scheduleId))).go();
  }

}