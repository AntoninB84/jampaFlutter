import 'package:jampa_flutter/data/models/Alarm.dart';

import '../data/dao/alarm_dao.dart';

class AlarmRepository {
  const AlarmRepository();

  Future<AlarmEntity> saveAlarm(AlarmEntity alarm) async {
    return await AlarmDao.saveSingleAlarm(alarm);
  }

  Future<void> saveAlarms(List<AlarmEntity> alarms) async {
    await AlarmDao.saveListOfAlarms(alarms);
  }

  Future<void> deleteAlarmById(int id) async {
    await AlarmDao.deleteAlarmById(id);
  }

  Stream<AlarmEntity?> watchAlarmById(int id)  {
    return AlarmDao.watchAlarmById(id);
  }

  Future<AlarmEntity?> getAlarmById(int id) async {
    return await AlarmDao.getAlarmById(id);
  }

  Future<List<AlarmEntity>> getAllAlarmsByScheduleId(int scheduleId) async {
    return await AlarmDao.getAllAlarmsByScheduleId(scheduleId);
  }

  Stream<List<AlarmEntity>> watchAllAlarmsByScheduleId(int scheduleId) {
    return AlarmDao.watchAllAlarmsByScheduleId(scheduleId);
  }

  Future<List<AlarmEntity>> getAllAlarms() async {
    return await AlarmDao.getAllAlarms();
  }
  Stream<List<AlarmEntity>> watchAllAlarms() {
    return AlarmDao.watchAllAlarms();
  }
}