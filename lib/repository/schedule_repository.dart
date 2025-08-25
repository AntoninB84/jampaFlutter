
import 'package:jampa_flutter/data/models/schedule.dart';

import '../data/dao/schedule_dao.dart';

class ScheduleRepository {
  const ScheduleRepository();

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