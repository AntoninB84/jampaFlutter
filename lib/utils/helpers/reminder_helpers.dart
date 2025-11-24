import 'package:alarm/alarm.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/enums/object_type_enum.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/helpers/utils.dart';

import '../enums/reminder_offset_type_enum.dart';
import '../local_notification_manager.dart';
import 'notification_helpers.dart';

/// Helper class to hold reminder setup information
/// Used when calculating and setting up reminders
class ReminderToSetup {

  /// The schedule associated with the reminder
  final ScheduleEntity schedule;

  /// The reminder to be set up
  final ReminderEntity reminder;

  /// The calculated date and time for the reminder
  final DateTime reminderDateTime;

  ReminderToSetup({
    required this.schedule,
    required this.reminder,
    required this.reminderDateTime,
  });
}

/// Helper class for managing reminders
abstract class ReminderHelpers {

  //region Reminder Date Calculations
  /// Calculate reminder dates for a list of schedules.
  /// Only reminders that fall within the next 2 days are considered
  static Future<List<ReminderToSetup>> calculateReminderDateFromSchedule(List<ScheduleEntity> schedules) async {
    DateTime now = DateTime.now();
    DateTime upperLimit = now.add(Duration(days: 2)); //Consider reminders only within the next 2 days
    List<ReminderToSetup> remindersDates = [];


    for(final schedule in schedules) {
      // Skip if no reminders
      if(schedule.reminders == null || schedule.reminders!.isEmpty) continue;

      // For each reminder, calculate the reminder date based on the schedule's recurrence type
      for(final reminder in schedule.reminders!) {
        DateTime reminderDate;
        switch(schedule.recurrenceType) {
          case RecurrenceType.intervalDays:
            reminderDate = await calculateReminderDateFromRecurringDateIntervalDays(schedule, reminder);
            break;
          case RecurrenceType.intervalYears:
            reminderDate = await calculateReminderDateFromRecurringDateIntervalYears(schedule, reminder);
            break;
          case RecurrenceType.dayBasedMonthly:
            reminderDate = await calculateReminderDateFromRecurringDateDayBasedMonths(schedule, reminder);
            break;
          case RecurrenceType.dayBasedWeekly:
            reminderDate = await calculateReminderDateFromRecurringDateDayBasedWeeks(schedule, reminder);
            break;
          default:
            reminderDate = await calculateReminderDateFromSingleDate(schedule, reminder);
            break;
        }

        // Only add if the reminder date is within the next 2 days
        if(reminderDate.isAfter(now) && reminderDate.isBefore(upperLimit)) {
          remindersDates.add(ReminderToSetup(
            schedule: schedule,
            reminder: reminder,
            reminderDateTime: reminderDate,
          ));
        }
      }
    }
    return remindersDates;
  }

  /// Calculate reminder date for single date schedules
  static Future<DateTime> calculateReminderDateFromSingleDate(ScheduleEntity schedule, ReminderEntity reminder) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    return startDate.subtract(getOffsetDuration(reminder));
  }

  /// Calculate reminder date for recurring schedules with interval in days
  static Future<DateTime> calculateReminderDateFromRecurringDateIntervalDays(ScheduleEntity schedule, ReminderEntity reminder) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the interval in days
    DateTime nextOccurrence = startDate;
    final int interval = schedule.recurrenceInterval ?? 1;
    // Loop until we find the next occurrence that is after the current date
    while(nextOccurrence.isBefore(DateTime.now())){
      nextOccurrence = nextOccurrence.add(Duration(days: interval));
    }
    // Subtract the reminder offset to get the reminder date
    return nextOccurrence.subtract(getOffsetDuration(reminder));
  }

  /// Calculate reminder date for recurring schedules with interval in years
  static Future<DateTime> calculateReminderDateFromRecurringDateIntervalYears(ScheduleEntity schedule, ReminderEntity reminder) async {
    final DateTime now = DateTime.now();
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the interval in years
    DateTime nextOccurrence = startDate;
    final int interval = schedule.recurrenceInterval ?? 1;
    // Loop until we find the next occurrence that is after the current date
    while(nextOccurrence.isBefore(now)){
      nextOccurrence = DateTime(
          nextOccurrence.year + interval,
          nextOccurrence.month,
          nextOccurrence.day,
          nextOccurrence.hour,
          nextOccurrence.minute,
          nextOccurrence.second
      );
    }
    // Subtract the reminder offset to get the reminder date
    return nextOccurrence.subtract(getOffsetDuration(reminder));
  }

  /// Calculate reminder date for recurring schedules based on day of the month
  static Future<DateTime> calculateReminderDateFromRecurringDateDayBasedMonths(ScheduleEntity schedule, ReminderEntity reminder) async {
    final DateTime now = DateTime.now();
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the day of the month
    DateTime nextOccurrence = startDate;
    final int dayOfMonth = schedule.recurrenceDay ?? startDate.day;
    // Loop until we find the next occurrence that is after the current date
    while(nextOccurrence.isBefore(now)) {
      nextOccurrence = DateTime(
          nextOccurrence.year,
          nextOccurrence.month + 1,
          dayOfMonth,
          nextOccurrence.hour,
          nextOccurrence.minute,
          nextOccurrence.second
      );
      //Handle cases where the day of month does not exist in the new month
      if (nextOccurrence.month != (nextOccurrence.month % 12) + 1) {
        nextOccurrence = DateTime(
            nextOccurrence.year,
            nextOccurrence.month,
            0, //Last day of previous month
            nextOccurrence.hour,
            nextOccurrence.minute,
            nextOccurrence.second
        );
      }
    }
    // Subtract the reminder offset to get the reminder date
    return nextOccurrence.subtract(getOffsetDuration(reminder));
  }

  /// Calculate reminder date for recurring schedules based on day of the week
  static Future<DateTime> calculateReminderDateFromRecurringDateDayBasedWeeks(ScheduleEntity schedule, ReminderEntity reminder) async {
    final DateTime now = DateTime.now();
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the day of the week
    DateTime nextOccurrence = startDate;
    final int dayOfWeek = schedule.recurrenceDay ?? startDate.weekday; //1 = Monday, 7 = Sunday
    // Loop until we find the next occurrence that is after the current date
    while(nextOccurrence.isBefore(now)) {
      nextOccurrence = nextOccurrence.add(Duration(days: 1));
      if (nextOccurrence.weekday == dayOfWeek) {
        break;
      }
    }
    // Subtract the reminder offset to get the reminder date
    return nextOccurrence.subtract(getOffsetDuration(reminder));
  }

  /// Get the offset duration from a reminder
  static Duration getOffsetDuration(ReminderEntity reminder) {
    switch(reminder.offsetType){
      case ReminderOffsetType.minutes:
        return Duration(minutes: reminder.offsetValue);
      case ReminderOffsetType.hours:
        return Duration(hours: reminder.offsetValue);
      case ReminderOffsetType.days:
        return Duration(days: reminder.offsetValue);
    }
  }
  //endregion

  /// Set a reminder based on the provided ReminderToSetup information
  static Future<void> setReminder(ReminderToSetup reminderToSetup) async {
    if(reminderToSetup.reminder.isNotification){
      // Schedule a notification
      await Utils.logMessage("Scheduling notification for reminder at ${reminderToSetup.reminderDateTime} for note id ${reminderToSetup.schedule.noteId}");
      await LocalNotificationManager().scheduleNotification(
          reminderToSetup.schedule.note?.title,
          "",
          NotificationData(
              notificationType: NotificationType.reminder,
              objectId: reminderToSetup.reminder.id.toString(),
              objectType: ObjectTypeEnum.reminderEntity.toString(),
              scheduledDate: reminderToSetup.reminderDateTime
          )
      );
    }else{
      // Schedule an alarm
      await Utils.logMessage("Scheduling alarm at ${reminderToSetup.reminderDateTime} for note id ${reminderToSetup.schedule.noteId}");
      final alarmSettings = AlarmSettings(
        id: reminderToSetup.hashCode,
        dateTime: reminderToSetup.reminderDateTime,
        assetAudioPath: 'assets/sounds/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 0.8,
          fadeDuration: Duration(seconds: 5),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: reminderToSetup.schedule.note?.title ?? 'Alarm',
          body: reminderToSetup.schedule.startDateTime?.toString() ?? '',
          stopButton: 'Stop',
        ),
        payload: "?objectId=${reminderToSetup.reminder.id}"
            "?objectType=${ObjectTypeEnum.reminderEntity}",
      );
      await Alarm.set(alarmSettings: alarmSettings);
    }
  }

  /// Cancel a reminder based on the provided NotificationPayload information
  static Future<void> cancelReminder(NotificationPayload notificationPayload) async {
    await Utils.logMessage("Cancelling reminder for id ${notificationPayload.objectId}");
    if(notificationPayload.alarmId != null){
      // Stop the alarm
      await Alarm.stop(notificationPayload.alarmId!);
    }
    if(notificationPayload.notificationId != null){
      // Remove the notification
      await LocalNotificationManager().removeNotification(notificationPayload.notificationId!);
    }
  }
}