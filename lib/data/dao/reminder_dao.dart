
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/reminder.dart';

import '../../utils/service_locator.dart';

class ReminderDao {

  static Future<ReminderEntity> saveSingleReminder(ReminderEntity reminder) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.into(db.reminderTable).insertReturning(
      reminder.toCompanion(),
      onConflict: DoUpdate((old) => reminder.toCompanion())
    );
  }

  static Future<void> saveListOfReminders(List<ReminderEntity> reminders) async {
    await Future.forEach(reminders, (reminderEntity) async {
      await saveSingleReminder(reminderEntity);
    });
  }

  static Stream<ReminderEntity?> watchReminderById(String id)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.reminderTable)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull();
  }

  static Future<ReminderEntity?> getReminderById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.reminderTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  static Stream<List<ReminderEntity>> watchAllReminders()  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.reminderTable))
        .watch();
  }

  static Future<List<ReminderEntity>> getAllReminders() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.reminderTable))
        .get();
  }

  static Stream<List<ReminderEntity>> watchAllRemindersByScheduleId(String scheduleId)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.reminderTable)..where((tbl) => tbl.scheduleId.equals(scheduleId)))
        .watch();
  }

  static Future<List<ReminderEntity>> getAllRemindersByScheduleId(String scheduleId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.reminderTable)..where((tbl) => tbl.scheduleId.equals(scheduleId)))
        .get();
  }

  static Future<void> deleteReminderById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.reminderTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  static Future<void> deleteRemindersByScheduleId(String scheduleId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.reminderTable)..where((tbl) => tbl.scheduleId.equals(scheduleId))).go();
  }

}