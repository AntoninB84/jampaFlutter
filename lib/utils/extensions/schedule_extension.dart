import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';

import '../enums/recurrence_type_enum.dart';
import '../enums/weekdays_enum.dart';

extension ScheduleExtension on ScheduleEntity {
  String displayNameAndValue(BuildContext context){
    String displayText = 'null';

    if(!isRecurring) {
      displayText = startDateTime?.toFullFormat(context) ?? 'null';
      return displayText;
    }
    switch(recurrenceType){
      case null:throw UnimplementedError();
      case RecurrenceType.intervalDays:
      case RecurrenceType.intervalYears:
        displayText = recurrenceType!.displayName(context,
          value: recurrenceInterval.toString(),
        );break;
      case RecurrenceType.dayBasedWeekly:
        displayText = recurrenceType!.displayName(context,
          value: WeekdaysEnum.weekdaysString(context, recurrenceDayAsList),
        ); break;
      case RecurrenceType.dayBasedMonthly:
        displayText = recurrenceType!.displayName(context,
          value: recurrenceDay.toString(),
        ); break;
    }
    return displayText;
  }

  bool get isRecurring {
    return recurrenceType != null;
  }

  List<int> get recurrenceDayAsList {
    if(recurrenceDay == null) return [];
    return recurrenceDay!.toString()
        .split('').map((e) => int.parse(e)).toList();
  }

  bool get recurrencyTypeNeedsIntervalValue {
    if(!isRecurring) return false;
    switch(recurrenceType){
      case RecurrenceType.intervalDays:
      case RecurrenceType.intervalYears:
        return true;
      case RecurrenceType.dayBasedMonthly:
      case RecurrenceType.dayBasedWeekly:
        return false;
      default:
        return false;
    }
  }

  /* Returns the next or last occurrence of this schedule.*/
  DateTime? nextOrLastOccurrence() {
    if(startDateTime == null) return null;

    DateTime now = DateTime.now();

    if(!isRecurring) {
      return startDateTime;
    }else {
      if(recurrencyTypeNeedsIntervalValue
          ? (recurrenceInterval == null || recurrenceInterval! <= 0)
          : (recurrenceDay == null || recurrenceDay! <= 0)) {
        return null;
      }

      // if startDateTime is in the future, return it
      // if beyond optional recurrenceEndDate, return last calculated date
      // if we get beyond now, return the calculated date
      DateTime? lastCalculatedDate;
      DateTime currentlyAnalysedDate = startDateTime!;
      while(true){
        if(currentlyAnalysedDate.isAfter(now)){
          return currentlyAnalysedDate;
        }
        if(recurrenceEndDate != null && currentlyAnalysedDate.isAfter(recurrenceEndDate!)){
          return lastCalculatedDate;
        }
        lastCalculatedDate = currentlyAnalysedDate;

        switch(recurrenceType){
          case RecurrenceType.intervalDays: {
            currentlyAnalysedDate = currentlyAnalysedDate.add(
                Duration(days: recurrenceInterval!)
            );
          }
          case RecurrenceType.intervalYears: {
            currentlyAnalysedDate = currentlyAnalysedDate.copyWith(
                year: currentlyAnalysedDate.year + recurrenceInterval!
            );
          }
          case RecurrenceType.dayBasedMonthly: {
            // Move to the next month with the same day
            // If the day exceeds the number of days in the month, it will automatically adjust
            // If the month exceeds 12, it will automatically adjust the year
            currentlyAnalysedDate = currentlyAnalysedDate.copyWith(
                day: recurrenceDay!,
                month: currentlyAnalysedDate.month + 1
            );
          }
          case RecurrenceType.dayBasedWeekly: {
            // The days of the schedule are based on recurrenceDay (1 = Monday, 7 = Sunday)
            // RecurrenceDay is a int containing all the days of the week the schedule occurs on
            // For example, if the schedule occurs on Monday, Wednesday and Friday, recurrenceDay = 135
            // We need to find the next occurrence based on the current day of the week
            int analysedWeekday = currentlyAnalysedDate.weekday; // 1 = Monday
            List<int> daysOfWeek = recurrenceDayAsList;

            if(daysOfWeek.contains(analysedWeekday)){
              currentlyAnalysedDate = currentlyAnalysedDate.add(
                  Duration(days: 1)
              );
            }
          }
          default: return null;
        }
      }
    }
    return null;
  }
}