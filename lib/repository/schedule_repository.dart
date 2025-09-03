
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/data/models/schedule.dart';

import '../data/dao/schedule_dao.dart';

class ScheduleRepository {
  const ScheduleRepository();

  Future<void> saveDateFormElements({
    List<SingleDateFormElements> singleFormElementsList = const [],
    List<RecurrenceFormElements> recurrenceFormElementsList = const [],
    required int noteId
  }) async {
    // Convert form elements to ScheduleEntity list
    // First handle single date elements
    List<ScheduleEntity> schedules = singleFormElementsList.map((formElements) {
      return ScheduleEntity.fromSingleDateFormElements(formElements, noteId);
    }).toList();
    // Then handle recurrence elements
    schedules.addAll(recurrenceFormElementsList.map((formElements) {
      return ScheduleEntity.fromRecurrenceFormElements(formElements, noteId);
    }).toList());

    await ScheduleDao.saveListOfSchedules(schedules);
  }

  Future<void> saveSingleDateFormElement({
    required SingleDateFormElements formElements,
    required int noteId
  }) async {
    final schedule = ScheduleEntity.fromSingleDateFormElements(formElements, noteId);
    await ScheduleDao.saveSingleSchedule(schedule);
  }

  Future<void> saveRecurrenceFormElement({
    required RecurrenceFormElements formElements,
    required int noteId
  }) async {
    final schedule = ScheduleEntity.fromRecurrenceFormElements(formElements, noteId);
    await ScheduleDao.saveSingleSchedule(schedule);
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