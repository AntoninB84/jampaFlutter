import 'package:jampa_flutter/data/models/alarm.dart';
import 'package:jampa_flutter/data/models/schedule.dart';

import '../enums/alarm_offset_type_enum.dart';

class AlarmHelpers {

  static Future<List<DateTime>> calculateAlarmDateFromSchedule(List<ScheduleEntity> schedules) async {
    DateTime now = DateTime.now();
    DateTime upperLimit = now.add(Duration(days: 2)); //Consider alarms only within the next 2 days
    List<DateTime> alarmDates = [];
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
          alarmDates.add(alarmDate);
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
    switch(alarm.alarmOffsetType){
      case AlarmOffsetType.minutes:
        return Duration(minutes: alarm.offsetValue);
      case AlarmOffsetType.hours:
        return Duration(hours: alarm.offsetValue);
      case AlarmOffsetType.days:
        return Duration(days: alarm.offsetValue);
    }
  }
}