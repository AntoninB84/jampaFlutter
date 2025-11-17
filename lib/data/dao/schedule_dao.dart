
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/alarm.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../utils/enums/note_status_enum.dart';

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

  static Future<void> deleteScheduleById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.scheduleTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  static Future<List<ScheduleEntity>> getAllSchedulesHavingAlarmsForToBeDoneNotes({
    required List<int> alarmIdsToExclude,
    bool useNewInstanceOfDb = true,
  }) async {
    AppDatabase db = useNewInstanceOfDb ? AppDatabase.instance() : serviceLocator<AppDatabase>();
    final query = db.select(db.scheduleTable).join([
      innerJoin(
        db.noteTable,
        db.noteTable.id.equalsExp(db.scheduleTable.noteId),
      ),
      innerJoin(
        db.alarmTable,
        db.alarmTable.scheduleId.equalsExp(db.scheduleTable.id),
      ),
    ])
      ..where(db.scheduleTable.recurrenceEndDate.isNull() | db.scheduleTable.recurrenceEndDate.isBiggerThanValue(DateTime.now()))
      ..where(db.alarmTable.id.isNotNull())
      ..where(db.noteTable.id.isNotIn(alarmIdsToExclude))
      ..where(db.noteTable.status.isNotIn([NoteStatusEnum.done.name]));

    final rows = await query.get();
    List<ScheduleEntity> schedules = [];
    for(final row in rows){
      ScheduleEntity scheduleEntity = row.readTable(db.scheduleTable);
      NoteEntity noteEntity = row.readTable(db.noteTable);
      AlarmEntity alarmEntity = row.readTable(db.alarmTable);

      // Check if the schedule already exists in the list
      final existingScheduleIndex = schedules.indexWhere((s) => s.id == scheduleEntity.id);
      if(existingScheduleIndex != -1){
        // If it exists, add the alarm to the existing schedule's alarms list
        if(schedules[existingScheduleIndex].alarms == null){
          schedules[existingScheduleIndex].alarms = [];
        }
        schedules[existingScheduleIndex].alarms!.add(alarmEntity);
      }else {
        // If it doesn't exist, create a new schedule with the alarm
        scheduleEntity.alarms = [alarmEntity];
        scheduleEntity.note = noteEntity;
        schedules.add(scheduleEntity);
      }

    }
    return schedules;
  }

  static Stream<List<ScheduleEntity>> watchAllSchedulesAndAlarmsByNoteId(int noteId) {
    AppDatabase db = serviceLocator<AppDatabase>();
    final query = db.select(db.scheduleTable).join([
      leftOuterJoin(
        db.alarmTable,
        db.alarmTable.scheduleId.equalsExp(db.scheduleTable.id),
      ),
    ])
      ..where(db.scheduleTable.noteId.equals(noteId));

    return query.watch().map((rows) {
      List<ScheduleEntity> schedules = [];
      for(final row in rows){
        ScheduleEntity scheduleEntity = row.readTable(db.scheduleTable);
        AlarmEntity? alarmEntity;
        try {
          alarmEntity = row.readTableOrNull(db.alarmTable);
        } catch (_) {
          alarmEntity = null;
        }

        // Check if the schedule already exists in the list
        final existingScheduleIndex = schedules.indexWhere((s) => s.id == scheduleEntity.id);
        if(existingScheduleIndex != -1){
          // If it exists, add the alarm to the existing schedule's alarms list
          if(alarmEntity != null){
            if(schedules[existingScheduleIndex].alarms == null){
              schedules[existingScheduleIndex].alarms = [];
            }
            schedules[existingScheduleIndex].alarms!.add(alarmEntity);
          }
        }else {
          // If it doesn't exist, create a new schedule with the alarm
          if(alarmEntity != null){
            scheduleEntity.alarms = [alarmEntity];
          }
          schedules.add(scheduleEntity);
        }
      }
      return schedules;
    });
  }
}