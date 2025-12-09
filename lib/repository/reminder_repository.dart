import 'package:jampa_flutter/data/models/reminder/reminder.dart';
import 'package:jampa_flutter/utils/storage/sync_storage_service.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../bloc/notes/form/note_form_helpers.dart';
import '../data/dao/reminder_dao.dart';

/// Repository for managing reminders.
class ReminderRepository {
  const ReminderRepository();

  /// Saves multiple reminder form elements associated with a schedule ID.
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

  /// Saves a single reminder form element associated with a schedule ID.
  Future<ReminderEntity> saveReminderFormElement({
    required ReminderFormElements formElements,
    required String scheduleId
  }) async {
    final reminder = ReminderEntity.fromReminderFormElements(formElements);
    return await ReminderDao.saveSingleReminder(reminder);
  }

  /// Saves a single reminder entity.
  Future<ReminderEntity> saveReminder(ReminderEntity reminder) async {
    return await ReminderDao.saveSingleReminder(reminder);
  }

  /// Saves multiple reminder entities.
  Future<void> saveReminders(List<ReminderEntity> reminders) async {
    await ReminderDao.saveListOfReminders(reminders);
  }

  /// Watches a single reminder by its ID.
  Stream<ReminderEntity?> watchReminderById(String id)  {
    return ReminderDao.watchReminderById(id);
  }

  /// Retrieves a single reminder by its ID.
  Future<ReminderEntity?> getReminderById(String id) async {
    return await ReminderDao.getReminderById(id);
  }

  /// Retrieves all reminders associated with a specific schedule ID.
  Future<List<ReminderEntity>> getAllRemindersByScheduleId(String scheduleId) async {
    return await ReminderDao.getAllRemindersByScheduleId(scheduleId);
  }

  /// Watches all reminders associated with a specific schedule ID.
  Stream<List<ReminderEntity>> watchAllRemindersByScheduleId(String scheduleId) {
    return ReminderDao.watchAllRemindersByScheduleId(scheduleId);
  }

  /// Retrieves all reminders from the database.
  Future<List<ReminderEntity>> getAllReminders() async {
    return await ReminderDao.getAllReminders();
  }

  /// Watches all reminders in the database.
  Stream<List<ReminderEntity>> watchAllReminders() {
    return ReminderDao.watchAllReminders();
  }

  /// Deletes a reminder by its ID.
  Future<void> deleteReminderById(String id) async {
    await ReminderDao.deleteReminderById(id);
    // Track deletion for sync
    try {
      final syncStorage = serviceLocator<SyncStorageService>();
      await syncStorage.addPendingDeletion('reminder', id);
    } catch (e) {
      // If sync storage is not available, continue without tracking
      print('Failed to track deletion for sync: $e');
    }
  }

  /// Deletes all reminders associated with a specific schedule ID.
  Future<void> deleteRemindersByScheduleId(String scheduleId) async {
    List<ReminderEntity> reminders = await getAllRemindersByScheduleId(scheduleId);
    for(var reminder in reminders) {
      await deleteReminderById(reminder.id);
    }
  }
}