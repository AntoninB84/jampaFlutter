import 'package:jampa_flutter/data/models/Alarm.dart';

import '../bloc/notes/create/create_note_form_helpers.dart';
import '../data/dao/alarm_dao.dart';

class AlarmRepository {
  const AlarmRepository();

  Future<void> saveAlarmFormElements({
    List<AlarmFormElements> alarmFormElementsList = const [],
    required int scheduleId
  }) async {
    // Convert form elements to AlarmEntity list
    List<AlarmEntity> alarms = alarmFormElementsList.map((formElements) {
      return AlarmEntity.fromAlarmFormElements(formElements, scheduleId);
    }).toList();

    await AlarmDao.saveListOfAlarms(alarms);
  }

  Future<void> saveAlarmFormElement({
    required AlarmFormElements formElements,
    required int scheduleId
  }) async {
    final alarm = AlarmEntity.fromAlarmFormElements(formElements, scheduleId);
    await AlarmDao.saveSingleAlarm(alarm);
  }

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