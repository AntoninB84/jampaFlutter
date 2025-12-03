import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/data/models/schedule/schedule.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';

import '../enums/recurrence_type_enum.dart';
import '../enums/weekdays_enum.dart';

/// Extension methods for ScheduleEntity
extension ScheduleExtension on ScheduleEntity {

  /// Returns a localized display string for the schedule,
  /// including recurrence information if applicable.
  ///
  /// For single dates, it returns the formatted start date.
  ///
  /// For recurring schedules, it returns a string based on the recurrence type:
  /// - Interval Days/Years: "Every X days/years"
  /// - Day-Based Weekly: "Every [Weekdays]"
  /// - Day-Based Monthly: "Every X day of the month"
  String displayNameAndValue(BuildContext context){
    String displayText = 'null';

    if(!isRecurring) {
      // Single date schedule
      displayText = startDateTime?.toFullFormat(context) ?? 'null';
      return displayText;
    }
    switch(recurrenceType){
      case null:throw UnimplementedError();
      case .intervalDays:
      case .intervalYears:
        displayText = recurrenceType!.displayName(context,
          value: recurrenceInterval.toString(),
        );break;
      case .dayBasedWeekly:
        displayText = recurrenceType!.displayName(context,
          value: WeekdaysEnum.weekdaysString(context, recurrenceDayAsList),
        ); break;
      case .dayBasedMonthly:
        displayText = recurrenceType!.displayName(context,
          value: recurrenceDay.toString(),
        ); break;
    }
    return displayText;
  }

  /// Returns true if the schedule is not a single date.
  bool get isRecurring {
    return recurrenceType != null;
  }

  /// Returns the recurrence days as a list of integers.
  /// For example, if recurrenceDay is 135, it returns [1, 3, 5].
  ///
  /// Is only of use for day-based weekly recurrences.
  /// If recurrenceDay is null, it returns an empty list.
  List<int> get recurrenceDayAsList {
    if(recurrenceDay == null) return [];
    return recurrenceDay!.toString()
        .split('').map((e) => int.parse(e)).toList();
  }

  /// Returns true if the recurrence type requires an interval value.
  /// For example, interval days and interval years need an interval value,
  /// while day-based monthly and day-based weekly do not (yet).
  bool get recurrencyTypeNeedsIntervalValue {
    if(!isRecurring) return false;
    switch(recurrenceType){
      case .intervalDays:
      case .intervalYears:
        return true;
      case .dayBasedMonthly:
      case .dayBasedWeekly:
        return false;
      default:
        return false;
    }
  }

  /// Returns the next or last occurrence of this schedule.
  DateTime? nextOrLastOccurrence() {
    if(startDateTime == null) return null;

    DateTime now = .now();

    if(!isRecurring) {
      // Single date schedule, return startDateTime
      return startDateTime;
    }else {
      // Recurring schedule
      if(recurrencyTypeNeedsIntervalValue
          ? (recurrenceInterval == null || recurrenceInterval! <= 0)
          : (recurrenceDay == null || recurrenceDay! <= 0)) {
        // Invalid recurrence settings
        return null;
      }

      // if startDateTime is in the future, return it
      // if beyond optional recurrenceEndDate, return last calculated date
      // if we get beyond now, return the calculated date
      DateTime? lastCalculatedDate;
      DateTime currentlyAnalysedDate = startDateTime!;
      while(true){
        // Loop until we find the next occurrence

        if(currentlyAnalysedDate.isAfter(now)){
          // The next occurrence is found as it is the first date after now
          return currentlyAnalysedDate;
        }

        if(recurrenceEndDate != null && currentlyAnalysedDate.isAfter(recurrenceEndDate!)){
          // We have gone beyond the recurrence end date, return the last calculated date
          return lastCalculatedDate;
        }

        // Update last calculated date now that we know it's before now
        lastCalculatedDate = currentlyAnalysedDate;

        switch(recurrenceType){
          case .intervalDays: {
            // Move forward by the recurrence interval in days
            currentlyAnalysedDate = currentlyAnalysedDate.add(
                Duration(days: recurrenceInterval!)
            );
          }
          case .intervalYears: {
            // Move forward by the recurrence interval in years
            currentlyAnalysedDate = currentlyAnalysedDate.copyWith(
                year: currentlyAnalysedDate.year + recurrenceInterval!
            );
          }
          case .dayBasedMonthly: {
            // Move to the next month with the same day
            // If the day exceeds the number of days in the month, it will automatically adjust
            // If the month exceeds 12, it will automatically adjust the year
            currentlyAnalysedDate = currentlyAnalysedDate.copyWith(
                day: recurrenceDay!,
                month: currentlyAnalysedDate.month + 1
            );
          }
          case .dayBasedWeekly: {
            // The days of the schedule are based on recurrenceDay (1 = Monday, 7 = Sunday)
            // RecurrenceDay is a int containing all the days of the week the schedule occurs on
            // For example, if the schedule occurs on Monday, Wednesday and Friday, recurrenceDay = 135
            // We need to find the next occurrence based on the current day of the week
            int analysedWeekday = currentlyAnalysedDate.weekday; // 1 = Monday
            List<int> daysOfWeek = recurrenceDayAsList;

            // Move to the next day until we find a matching weekday
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
  }
}