
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/data/models/schedule.dart';

import '../data/dao/schedule_dao.dart';
import '../utils/service_locator.dart';
import 'alarm_repository.dart';

class ScheduleRepository {
  const ScheduleRepository();

  Future<void> saveDateFormElements({
    List<SingleDateFormElements> singleFormElementsList = const [],
    List<RecurrenceFormElements> recurrenceFormElementsList = const [],
    required int noteId
  }) async {
    // Convert form elements to ScheduleEntity list
    // First handle single date elements
    for(var formElements in singleFormElementsList) {
      await saveSingleDateFormElement(formElements: formElements, noteId: noteId);
    }
    // Then handle recurrence elements
    for(var formElements in recurrenceFormElementsList) {
      await saveRecurrenceFormElement(formElements: formElements, noteId: noteId);
    }
  }

  Future<void> saveSingleDateFormElement({
    required SingleDateFormElements formElements,
    required int noteId
  }) async {
    final schedule = ScheduleEntity.fromSingleDateFormElements(formElements, noteId);
    final ScheduleEntity savedSchedule = await ScheduleDao.saveSingleSchedule(schedule);
    // If there are alarms associated with this single date, save them too
    for (var alarm in formElements.alarmsForSingleDate) {
      await serviceLocator<AlarmRepository>().saveAlarmFormElement(
          formElements: alarm,
          scheduleId: savedSchedule.id!,
      );
    }
  }

  Future<void> saveRecurrenceFormElement({
    required RecurrenceFormElements formElements,
    required int noteId
  }) async {
    final schedule = ScheduleEntity.fromRecurrenceFormElements(formElements, noteId);
    final ScheduleEntity savedSchedule = await ScheduleDao.saveSingleSchedule(schedule);
    // If there are alarms associated with this single date, save them too
    for (var alarm in formElements.alarmsForRecurrence) {
      await serviceLocator<AlarmRepository>().saveAlarmFormElement(
        formElements: alarm,
        scheduleId: savedSchedule.id!,
      );
    }
  }

  Future<ScheduleEntity> saveSchedule(ScheduleEntity schedule) async {
    return await ScheduleDao.saveSingleSchedule(schedule);
  }

  Future<void> saveSchedules(List<ScheduleEntity> schedules) async {
    await ScheduleDao.saveListOfSchedules(schedules);
  }

  Future<void> deleteScheduleById(int id) async {
    await ScheduleDao.deleteScheduleById(id);
  }

  Stream<ScheduleEntity?> watchScheduleById(int id)  {
    return ScheduleDao.watchScheduleById(id);
  }

  Future<ScheduleEntity?> getScheduleById(int id) async {
    return await ScheduleDao.getScheduleById(id);
  }

  Future<List<ScheduleEntity>> getAllSchedulesByNoteId(int noteId) async {
    return await ScheduleDao.getAllSchedulesByNoteId(noteId);
  }

  Stream<List<ScheduleEntity>> watchAllSchedulesByNoteId(int noteId) {
    return ScheduleDao.watchAllSchedulesByNoteId(noteId);
  }

  Future<List<ScheduleEntity>> getAllSchedules() async {
    return await ScheduleDao.getAllSchedules();
  }

  Stream<List<ScheduleEntity>> watchAllSchedules() {
    return ScheduleDao.watchAllSchedules();
  }

}