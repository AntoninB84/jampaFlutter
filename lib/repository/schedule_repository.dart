
import 'package:collection/collection.dart';
import 'package:jampa_flutter/bloc/notes/form/note_form_helpers.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/data/objects/schedule_with_next_occurrence.dart';
import 'package:jampa_flutter/utils/extensions/schedule_extension.dart';

import '../data/dao/schedule_dao.dart';
import '../utils/service_locator.dart';
import 'reminder_repository.dart';

class ScheduleRepository {
  const ScheduleRepository();

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

  Future<ScheduleEntity> saveSingleDateFormElement({
    required SingleDateFormElements formElements,
    required String noteId
  }) async {
    final schedule = ScheduleEntity.fromSingleDateFormElements(formElements);
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  Future<ScheduleEntity> saveRecurrenceFormElement({
    required RecurrenceFormElements formElements,
    required String noteId
  }) async {
    final schedule = ScheduleEntity.fromRecurrenceFormElements(formElements);
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  Future<ScheduleEntity> saveSchedule(ScheduleEntity schedule) async {
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  Future<void> saveSchedules(List<ScheduleEntity> schedules) async {
    await ScheduleDao.saveListOfSchedules(schedules);
  }

  Stream<ScheduleEntity?> watchScheduleById(String id)  {
    return ScheduleDao.watchScheduleById(id);
  }

  Future<ScheduleEntity?> getScheduleById(String id) async {
    return await ScheduleDao.getScheduleById(id);
  }

  Future<List<ScheduleEntity>> getAllSchedulesByNoteId(String noteId) async {
    return await ScheduleDao.getAllSchedulesByNoteId(noteId);
  }

  Stream<List<ScheduleEntity>> watchAllSchedulesByNoteId(String noteId) {
    return ScheduleDao.watchAllSchedulesByNoteId(noteId);
  }

  Stream<List<ScheduleWithNextOccurrence>> watchAllSchedulesAndAlarmsByNoteId(String noteId) {
    return ScheduleDao.watchAllSchedulesAndRemindersByNoteId(noteId).map((schedules) {
      return schedules.map((schedule) {
        DateTime? nextOccurrence = schedule.nextOrLastOccurrence();
        return ScheduleWithNextOccurrence(
          schedule: schedule,
          nextOccurrence: nextOccurrence,
        );
      }).sorted((ScheduleWithNextOccurrence a, ScheduleWithNextOccurrence b) {
        if(a.nextOccurrence == null && b.nextOccurrence == null) return 0;
        if(a.nextOccurrence == null) return 1;
        if(b.nextOccurrence == null) return -1;
        return b.nextOccurrence!.compareTo(a.nextOccurrence!);
      }).toList();
    });
  }

  Future<List<ScheduleEntity>> getAllSchedules() async {
    return await ScheduleDao.getAllSchedules();
  }

  Stream<List<ScheduleEntity>> watchAllSchedules() {
    return ScheduleDao.watchAllSchedules();
  }

  Future<void> deleteScheduleById(String id) async {
    await serviceLocator<ReminderRepository>().deleteRemindersByScheduleId(id);
    await ScheduleDao.deleteScheduleById(id);
  }

  Future<void> deleteSchedulesByNoteId(String noteId) async {
    List<ScheduleEntity> schedules = await getAllSchedulesByNoteId(noteId);
    for(var schedule in schedules) {
      await deleteScheduleById(schedule.id);
    }
  }

}