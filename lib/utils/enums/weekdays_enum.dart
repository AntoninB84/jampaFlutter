import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

/// Enum representing the days of the week
/// Useful for scheduling recurring events based on dayBasedWeekly recurrence
enum WeekdaysEnum {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  const WeekdaysEnum(this.asInt);

  final int asInt;

  /// Get the enum value from an integer representation of the day
  static WeekdaysEnum fromInt(int day) {
    return .values.firstWhere((element) => element.asInt == day);
  }

  /// Get the localized display name of the weekday
  String displayName(BuildContext context) {
    return weekdayIntToString(context, asInt);
  }

  /// Convert a list of weekday integers to a localized string representation
  static String weekdaysString (BuildContext context, List<int> weekDays) {
    if(weekDays.isEmpty) return '';
    if(weekDays.length == 1) {
      return weekdayIntToString(context, weekDays[0]);
    }
    if(weekDays.length > 1 && weekDays.length < 7) {
      String result = '';
      for(int i = 0; i < weekDays.length; i++) {
        result += weekdayIntToString(context, weekDays[i]).substring(0, 2);
        if(i < weekDays.length - 1) result += ', ';
      }
      return result;
    }
    if(weekDays.length == 7) return context.strings.everyday;
    return '';
  }

  /// Convert a single weekday integer to its localized string representation
  static String weekdayIntToString (BuildContext context, int weekDay) {
    switch(weekDay) {
      case 1: return context.strings.monday;
      case 2: return context.strings.tuesday;
      case 3: return context.strings.wednesday;
      case 4: return context.strings.thursday;
      case 5: return context.strings.friday;
      case 6: return context.strings.saturday;
      case 7: return context.strings.sunday;
      default: return '';
    }
  }
}