
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

class ScheduleDao {
  static Future<ScheduleEntity> saveSingleSchedule(ScheduleEntity schedule) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    // Insert or update the schedule
    return await db.into(db.scheduleTable).insertReturning(
      schedule.toCompanion(),
      onConflict: DoUpdate((old) => schedule.toCompanion())
    );
  }

  static Future<void> saveListOfSchedules(List<ScheduleEntity> schedules) async {
    await Future.forEach(schedules, (scheduleEntity) async {
      await saveSingleSchedule(scheduleEntity);
    });
  }

  static Stream<ScheduleEntity?> watchScheduleById(int id)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.scheduleTable)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull();
  }

  static Future<ScheduleEntity?> getScheduleById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.scheduleTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  static Future<void> deleteScheduleById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.scheduleTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  static Stream<List<ScheduleEntity>> watchAllSchedulesByNoteId(int noteId)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.scheduleTable)..where((tbl) => tbl.noteId.equals(noteId)))
        .watch();
  }

  static Future<List<ScheduleEntity>> getAllSchedulesByNoteId(int noteId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.scheduleTable)..where((tbl) => tbl.noteId.equals(noteId)))
        .get();
  }

  static Stream<List<ScheduleEntity>> watchAllSchedules()  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return db.select(db.scheduleTable).watch();
  }

  static Future<List<ScheduleEntity>> getAllSchedules() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.select(db.scheduleTable).get();
  }
}