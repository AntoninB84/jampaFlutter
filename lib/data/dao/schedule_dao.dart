
import 'package:drift/drift.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../utils/enums/note_status_enum.dart';

/// Data Access Object (DAO) for [ScheduleEntity]
class ScheduleDao {

  /// Saves a single schedule to the database.
  /// If a schedule with the same ID already exists, it will be updated.
  /// Returns the saved [ScheduleEntity].
  static Future<ScheduleEntity> saveSingleSchedule(ScheduleEntity schedule) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    // Insert or update the schedule
    return await db.into(db.scheduleTable).insertReturning(
      schedule.toCompanion(),
      onConflict: DoUpdate((old) => schedule.toCompanion())
    );
  }

  /// Saves a list of schedules to the database individually.
  /// If a schedule with the same ID already exists, it will be updated.
  static Future<void> saveListOfSchedules(List<ScheduleEntity> schedules) async {
    await Future.forEach(schedules, (scheduleEntity) async {
      await saveSingleSchedule(scheduleEntity);
    });
  }

  /// Watches a single schedule by its ID.
  /// Returns a [Stream] that emits the [ScheduleEntity] whenever it changes.
  static Stream<ScheduleEntity?> watchScheduleById(String id)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.scheduleTable)..where((tbl) => tbl.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Retrieves a single schedule by its ID.
  /// Returns the [ScheduleEntity] if found, otherwise returns null.
  static Future<ScheduleEntity?> getScheduleById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.scheduleTable)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watches all schedules associated with a specific note ID.
  /// Returns a [Stream] that emits a list of [ScheduleEntity]s whenever they change.
  static Stream<List<ScheduleEntity>> watchAllSchedulesByNoteId(String noteId)  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.scheduleTable)..where((tbl) => tbl.noteId.equals(noteId)))
        .watch();
  }

  /// Retrieves all schedules associated with a specific note ID.
  static Future<List<ScheduleEntity>> getAllSchedulesByNoteId(String noteId) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.scheduleTable)..where((tbl) => tbl.noteId.equals(noteId)))
        .get();
  }

  /// Watches all schedules in the database.
  static Stream<List<ScheduleEntity>> watchAllSchedules()  {
    AppDatabase db = serviceLocator<AppDatabase>();
    return db.select(db.scheduleTable).watch();
  }

  /// Retrieves all schedules in the database.
  static Future<List<ScheduleEntity>> getAllSchedules() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.select(db.scheduleTable).get();
  }

  /// Deletes a schedule by its ID.
  static Future<void> deleteScheduleById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.scheduleTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Retrieves all schedules that have reminders associated with notes that are not done,
  /// excluding those with specified reminder IDs.
  ///
  /// [remindersIdsToExclude] is a list of reminder IDs to exclude from the results.
  static Future<List<ScheduleEntity>> getAllSchedulesHavingRemindersForToBeDoneNotes({
    required List<String?> remindersIdsToExclude,
    bool useNewInstanceOfDb = true,
  }) async {
    AppDatabase db = useNewInstanceOfDb ? AppDatabase.instance() : serviceLocator<AppDatabase>();
    final query = db.select(db.scheduleTable).join([
      innerJoin(
        db.noteTable,
        db.noteTable.id.equalsExp(db.scheduleTable.noteId),
      ),
      innerJoin(
        db.reminderTable,
        db.reminderTable.scheduleId.equalsExp(db.scheduleTable.id),
      ),
    ])
      ..where(db.scheduleTable.recurrenceEndDate.isNull() | db.scheduleTable.recurrenceEndDate.isBiggerThanValue(DateTime.now()))
      ..where(db.reminderTable.id.isNotNull())
      ..where(db.noteTable.id.isNotIn(remindersIdsToExclude.map((e) => e ?? "").toList()))
      ..where(db.noteTable.status.isNotIn([NoteStatusEnum.done.name]));

    final rows = await query.get();
    List<ScheduleEntity> schedules = [];
    for(final row in rows){
      ScheduleEntity scheduleEntity = row.readTable(db.scheduleTable);
      NoteEntity noteEntity = row.readTable(db.noteTable);
      ReminderEntity alarmEntity = row.readTable(db.reminderTable);

      // Check if the schedule already exists in the list
      final existingScheduleIndex = schedules.indexWhere((s) => s.id == scheduleEntity.id);
      if(existingScheduleIndex != -1){
        // If it exists, add the alarm to the existing schedule's alarms list
        if(schedules[existingScheduleIndex].reminders == null){
          schedules[existingScheduleIndex].reminders = [];
        }
        schedules[existingScheduleIndex].reminders!.add(alarmEntity);
      }else {
        // If it doesn't exist, create a new schedule with the alarm
        scheduleEntity.reminders = [alarmEntity];
        scheduleEntity.note = noteEntity;
        schedules.add(scheduleEntity);
      }

    }
    return schedules;
  }

  static Stream<List<ScheduleEntity>> watchAllSchedulesAndRemindersByNoteId(String noteId) {
    AppDatabase db = serviceLocator<AppDatabase>();
    final query = db.select(db.scheduleTable).join([
      leftOuterJoin(
        db.reminderTable,
        db.reminderTable.scheduleId.equalsExp(db.scheduleTable.id),
      ),
    ])
      ..where(db.scheduleTable.noteId.equals(noteId));

    return query.watch().map((rows) {
      List<ScheduleEntity> schedules = [];
      for(final row in rows){
        ScheduleEntity scheduleEntity = row.readTable(db.scheduleTable);
        ReminderEntity? alarmEntity;
        try {
          alarmEntity = row.readTableOrNull(db.reminderTable);
        } catch (_) {
          alarmEntity = null;
        }

        // Check if the schedule already exists in the list
        final existingScheduleIndex = schedules.indexWhere((s) => s.id == scheduleEntity.id);
        if(existingScheduleIndex != -1){
          // If it exists, add the alarm to the existing schedule's alarms list
          if(alarmEntity != null){
            if(schedules[existingScheduleIndex].reminders == null){
              schedules[existingScheduleIndex].reminders = [];
            }
            schedules[existingScheduleIndex].reminders!.add(alarmEntity);
          }
        }else {
          // If it doesn't exist, create a new schedule with the alarm
          if(alarmEntity != null){
            scheduleEntity.reminders = [alarmEntity];
          }
          schedules.add(scheduleEntity);
        }
      }
      return schedules;
    });
  }
}