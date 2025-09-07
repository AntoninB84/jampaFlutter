
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/alarm.dart';

import '../../utils/service_locator.dart';

class AlarmDao {

  static Future<AlarmEntity> saveSingleAlarm(AlarmEntity alarm) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.into(db.alarmTable).insertReturning(
      alarm.toCompanion(),
      onConflict: DoUpdate((old) => alarm.toCompanion())
    );
  }

  static Future<void> saveListOfAlarms(List<AlarmEntity> alarms) async {
    await Future.forEach(alarms, (alarmEntity) async {
      await saveSingleAlarm(alarmEntity);
    });
  }

  static Stream<AlarmEntity?> watchAlarmById(int id)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.alarmTable)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull();
  }

  static Future<AlarmEntity?> getAlarmById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.alarmTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  static Future<void> deleteAlarmById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.alarmTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  static Stream<List<AlarmEntity>> watchAllAlarms()  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.alarmTable))
        .watch();
  }

  static Future<List<AlarmEntity>> getAllAlarms() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.alarmTable))
        .get();
  }

  static Stream<List<AlarmEntity>> watchAllAlarmsByScheduleId(int scheduleId)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.alarmTable)..where((tbl) => tbl.scheduleId.equals(scheduleId)))
        .watch();
  }

  static Future<List<AlarmEntity>> getAllAlarmsByScheduleId(int scheduleId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.alarmTable)..where((tbl) => tbl.scheduleId.equals(scheduleId)))
        .get();
  }

}