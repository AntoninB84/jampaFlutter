import 'package:jampa_flutter/data/models/reminder.dart';

import '../bloc/notes/form/note_form_helpers.dart';
import '../data/dao/reminder_dao.dart';

class ReminderRepository {
  const ReminderRepository();

  Future<void> saveReminderFormElements({
    List<ReminderFormElements> reminderFormElementsList = const [],
    required String scheduleId
  }) async {
    // Convert form elements to AlarmEntity list
    List<ReminderEntity> reminders = reminderFormElementsList.map((formElements) {
      return ReminderEntity.fromReminderFormElements(formElements);
    }).toList();

    await ReminderDao.saveListOfReminders(reminders);
  }

  Future<ReminderEntity> saveReminderFormElement({
    required ReminderFormElements formElements,
    required String scheduleId
  }) async {
    final reminder = ReminderEntity.fromReminderFormElements(formElements);
    return await ReminderDao.saveSingleReminder(reminder);
  }

  Future<ReminderEntity> saveReminder(ReminderEntity reminder) async {
    return await ReminderDao.saveSingleReminder(reminder);
  }

  Future<void> saveReminders(List<ReminderEntity> reminders) async {
    await ReminderDao.saveListOfReminders(reminders);
  }

  Stream<ReminderEntity?> watchReminderById(String id)  {
    return ReminderDao.watchReminderById(id);
  }

  Future<ReminderEntity?> getReminderById(String id) async {
    return await ReminderDao.getReminderById(id);
  }

  Future<List<ReminderEntity>> getAllRemindersByScheduleId(String scheduleId) async {
    return await ReminderDao.getAllRemindersByScheduleId(scheduleId);
  }

  Stream<List<ReminderEntity>> watchAllRemindersByScheduleId(String scheduleId) {
    return ReminderDao.watchAllRemindersByScheduleId(scheduleId);
  }

  Future<List<ReminderEntity>> getAllReminders() async {
    return await ReminderDao.getAllReminders();
  }
  Stream<List<ReminderEntity>> watchAllReminders() {
    return ReminderDao.watchAllReminders();
  }

  Future<void> deleteReminderById(String id) async {
    await ReminderDao.deleteReminderById(id);
  }

  Future<void> deleteRemindersByScheduleId(String scheduleId) async {
    await ReminderDao.deleteRemindersByScheduleId(scheduleId);
  }
}