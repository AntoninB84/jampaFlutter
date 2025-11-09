import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:jampa_flutter/data/models/alarm.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/enums/object_type_enum.dart';
import 'package:jampa_flutter/utils/helpers/utils.dart';

import '../enums/alarm_offset_type_enum.dart';
import '../local_notification_manager.dart';
import 'notification_helpers.dart';

class AlarmToSetup {
  final ScheduleEntity schedule;
  final AlarmEntity alarm;
  final DateTime alarmDateTime;

  AlarmToSetup({
    required this.schedule,
    required this.alarm,
    required this.alarmDateTime,
  });
}

abstract class AlarmHelpers {

  //region Alarm Date Calculations
  static Future<List<AlarmToSetup>> calculateAlarmDateFromSchedule(List<ScheduleEntity> schedules) async {
    DateTime now = DateTime.now();
    DateTime upperLimit = now.add(Duration(days: 2)); //Consider alarms only within the next 2 days
    List<AlarmToSetup> alarmDates = [];
    for(final schedule in schedules) {
      if(schedule.alarms == null || schedule.alarms!.isEmpty) continue;
      for(final alarm in schedule.alarms!) {
        DateTime alarmDate;
        switch(schedule.recurrenceType) {
          case 'intervalDays':
            alarmDate = await calculateAlarmDateFromRecurringDateIntervalDays(schedule, alarm);
            break;
          case 'intervalYears':
            alarmDate = await calculateAlarmDateFromRecurringDateIntervalYears(schedule, alarm);
            break;
          case 'dayBasedMonthly':
            alarmDate = await calculateAlarmDateFromRecurringDateDayBasedMonths(schedule, alarm);
            break;
          case 'dayBasedWeekly':
            alarmDate = await calculateAlarmDateFromRecurringDateDayBasedWeeks(schedule, alarm);
            break;
          default:
            alarmDate = await calculateAlarmDateFromSingleDate(schedule, alarm);
            break;
        }
        if(alarmDate.isAfter(now) && alarmDate.isBefore(upperLimit)) {
          alarmDates.add(AlarmToSetup(
            schedule: schedule,
            alarm: alarm,
            alarmDateTime: alarmDate,
          ));
        }
      }
    }
    return alarmDates;
  }

  static Future<DateTime> calculateAlarmDateFromSingleDate(ScheduleEntity schedule, AlarmEntity alarm) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    return startDate.subtract(getOffsetDuration(alarm));
  }

  static Future<DateTime> calculateAlarmDateFromRecurringDateIntervalDays(ScheduleEntity schedule, AlarmEntity alarm) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the interval in days
    DateTime nextOccurrence = startDate;
    final int interval = schedule.recurrenceInterval ?? 1;
    while(nextOccurrence.isBefore(DateTime.now())){
      nextOccurrence = nextOccurrence.add(Duration(days: interval));
    }
    return nextOccurrence.subtract(getOffsetDuration(alarm));
  }

  static Future<DateTime> calculateAlarmDateFromRecurringDateIntervalYears(ScheduleEntity schedule, AlarmEntity alarm) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the interval in years
    DateTime nextOccurrence = startDate;
    final int interval = schedule.recurrenceInterval ?? 1;
    while(nextOccurrence.isBefore(DateTime.now())){
      nextOccurrence = DateTime(
          nextOccurrence.year + interval,
          nextOccurrence.month,
          nextOccurrence.day,
          nextOccurrence.hour,
          nextOccurrence.minute,
          nextOccurrence.second
      );
    }
    return nextOccurrence.subtract(getOffsetDuration(alarm));
  }

  static Future<DateTime> calculateAlarmDateFromRecurringDateDayBasedMonths(ScheduleEntity schedule, AlarmEntity alarm) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the day of the month
    DateTime nextOccurrence = startDate;
    final int dayOfMonth = schedule.recurrenceDay ?? startDate.day;
    while(nextOccurrence.isBefore(DateTime.now())) {
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
    return nextOccurrence.subtract(getOffsetDuration(alarm));
  }

  static Future<DateTime> calculateAlarmDateFromRecurringDateDayBasedWeeks(ScheduleEntity schedule, AlarmEntity alarm) async {
    final DateTime startDate = schedule.startDateTime ?? schedule.createdAt;
    //Find the next occurrence based on the day of the week
    DateTime nextOccurrence = startDate;
    final int dayOfWeek = schedule.recurrenceDay ?? startDate.weekday; //1 = Monday, 7 = Sunday
    while(nextOccurrence.isBefore(DateTime.now())) {
      nextOccurrence = nextOccurrence.add(Duration(days: 1));
      if (nextOccurrence.weekday == dayOfWeek) {
        break;
      }
    }
    return nextOccurrence.subtract(getOffsetDuration(alarm));
  }

  static Duration getOffsetDuration(AlarmEntity alarm) {
    switch(alarm.offsetType){
      case AlarmOffsetType.minutes:
        return Duration(minutes: alarm.offsetValue);
      case AlarmOffsetType.hours:
        return Duration(hours: alarm.offsetValue);
      case AlarmOffsetType.days:
        return Duration(days: alarm.offsetValue);
    }
  }
  //endregion

  static Future<void> setAlarmNotification(AlarmToSetup alarmToSetup) async {
    print(alarmToSetup.alarmDateTime);
    if(alarmToSetup.alarm.isSilent){
      // Schedule silent notification
      await Utils.logMessage("Scheduling silent notification for alarm at ${alarmToSetup.alarmDateTime} for note id ${alarmToSetup.schedule.noteId}");
      await LocalNotificationManager().scheduleNotification(
          alarmToSetup.schedule.note?.title,
          "",
          NotificationData(
              notificationType: NotificationType.reminder,
              objectId: alarmToSetup.alarm.id.toString(),
              objectType: ObjectTypeEnum.alarmEntity.toString(),
              scheduledDate: alarmToSetup.alarmDateTime
          )
      );
    }else{
      // Schedule actual alarm
      await Utils.logMessage("Scheduling alarm at ${alarmToSetup.alarmDateTime} for note id ${alarmToSetup.schedule.noteId}");
      final alarmSettings = AlarmSettings(
        id: alarmToSetup.alarm.id ?? alarmToSetup.hashCode,
        dateTime: alarmToSetup.alarmDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 0.8,
          fadeDuration: Duration(seconds: 5),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: alarmToSetup.schedule.note?.title ?? 'Alarm',
          body: alarmToSetup.schedule.startDateTime?.toString() ?? '',
          stopButton: 'Stop',
        ),
        payload: "?objectId=${alarmToSetup.alarm.id}"
            "?objectType=${ObjectTypeEnum.alarmEntity}",
      );
      await Alarm.set(alarmSettings: alarmSettings);
    }
  }

  static Future<void> cancelAlarmNotification(NotificationPayload notificationPayload) async {
    await Utils.logMessage("Cancelling alarm notification for alarm id ${notificationPayload.objectId}");
    if(notificationPayload.alarmId != null){
      await Alarm.stop(notificationPayload.alarmId!);
    }
    if(notificationPayload.notificationId != null){
      await LocalNotificationManager().removeNotification(notificationPayload.notificationId!);
    }
  }
}