
import 'package:collection/collection.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/data/models/schedule/schedule.dart';
import 'package:jampa_flutter/data/objects/schedule_with_next_occurrence.dart';
import 'package:jampa_flutter/utils/extensions/schedule_extension.dart';

import '../data/dao/schedule_dao.dart';
import '../utils/service_locator.dart';
import 'reminder_repository.dart';

/// Repository for managing schedules.
class ScheduleRepository {
  const ScheduleRepository();

  /// Saves date form elements (both single date and recurrence) associated with a note ID.
  /// Returns a list of saved [ScheduleEntity]s.
  Future<List<ScheduleEntity>> saveDateFormElements({
    List<SingleDateFormElements> singleFormElementsList = const [],
    List<RecurrenceFormElements> recurrenceFormElementsList = const [],
    required String noteId
  }) async {
    List<ScheduleEntity> schedulesSaved = [];
    // Convert form elements to ScheduleEntity list
    // First handle single date elements
    for(var formElements in singleFormElementsList) {
      schedulesSaved.add(await saveSingleDateFormElement(formElements: formElements, noteId: noteId));
    }
    // Then handle recurrence elements
    for(var formElements in recurrenceFormElementsList) {
      schedulesSaved.add(await saveRecurrenceFormElement(formElements: formElements, noteId: noteId));
    }
    return schedulesSaved;
  }

  /// Saves a single date form element associated with a note ID.
  /// Returns the saved [ScheduleEntity].
  Future<ScheduleEntity> saveSingleDateFormElement({
    required SingleDateFormElements formElements,
    required String noteId
  }) async {
    final schedule = ScheduleEntity.fromSingleDateFormElements(formElements);
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  /// Saves a recurrence form element associated with a note ID.
  /// Returns the saved [ScheduleEntity].
  Future<ScheduleEntity> saveRecurrenceFormElement({
    required RecurrenceFormElements formElements,
    required String noteId
  }) async {
    final schedule = ScheduleEntity.fromRecurrenceFormElements(formElements);
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  /// Saves a single [ScheduleEntity].
  Future<ScheduleEntity> saveSchedule(ScheduleEntity schedule) async {
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  /// Saves a list of [ScheduleEntity]s.
  Future<void> saveSchedules(List<ScheduleEntity> schedules) async {
    await ScheduleDao.saveListOfSchedules(schedules);
  }

  /// Watches a single schedule by its ID.
  Stream<ScheduleEntity?> watchScheduleById(String id)  {
    return ScheduleDao.watchScheduleById(id);
  }

  /// Retrieves a single schedule by its ID.
  Future<ScheduleEntity?> getScheduleById(String id) async {
    return await ScheduleDao.getScheduleById(id);
  }

  /// Retrieves all schedules associated with a specific note ID.
  Future<List<ScheduleEntity>> getAllSchedulesByNoteId(String noteId) async {
    return await ScheduleDao.getAllSchedulesByNoteId(noteId);
  }

  /// Watches all schedules associated with a specific note ID.
  Stream<List<ScheduleEntity>> watchAllSchedulesByNoteId(String noteId) {
    return ScheduleDao.watchAllSchedulesByNoteId(noteId);
  }

  /// Watches all schedules and their next occurrences associated with a specific note ID.
  Stream<List<ScheduleWithNextOccurrence>> watchAllSchedulesAndAlarmsByNoteId(String noteId) {
    return ScheduleDao.watchAllSchedulesAndRemindersByNoteId(noteId).map((schedules) {
      return schedules.map((schedule) {
        // Calculate next occurrence for each schedule
        DateTime? nextOccurrence = schedule.nextOrLastOccurrence();
        // Return [ScheduleWithNextOccurrence] object
        return ScheduleWithNextOccurrence(
          schedule: schedule,
          nextOccurrence: nextOccurrence,
        );
      }).sorted((ScheduleWithNextOccurrence a, ScheduleWithNextOccurrence b) {
        // Sort by next occurrence date, placing nulls at the end
        if(a.nextOccurrence == null && b.nextOccurrence == null) return 0;
        if(a.nextOccurrence == null) return 1;
        if(b.nextOccurrence == null) return -1;
        return b.nextOccurrence!.compareTo(a.nextOccurrence!);
      }).toList();
    });
  }

  /// Retrieves all schedules in the database.
  Future<List<ScheduleEntity>> getAllSchedules() async {
    return await ScheduleDao.getAllSchedules();
  }

  /// Watches all schedules in the database.
  Stream<List<ScheduleEntity>> watchAllSchedules() {
    return ScheduleDao.watchAllSchedules();
  }

  /// Deletes a schedule by its ID, along with associated reminders.
  Future<void> deleteScheduleById(String id) async {
    await serviceLocator<ReminderRepository>().deleteRemindersByScheduleId(id);
    await ScheduleDao.deleteScheduleById(id);
  }

  /// Deletes all schedules associated with a specific note ID, along with their associated reminders.
  Future<void> deleteSchedulesByNoteId(String noteId) async {
    List<ScheduleEntity> schedules = await getAllSchedulesByNoteId(noteId);
    for(var schedule in schedules) {
      await deleteScheduleById(schedule.id);
    }
  }

}