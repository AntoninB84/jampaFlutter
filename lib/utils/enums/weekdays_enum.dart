import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

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

  static WeekdaysEnum fromInt(int day) {
    return WeekdaysEnum.values.firstWhere((element) => element.asInt == day);
  }

  String displayName(BuildContext context) {
    return weekdayIntToString(context, asInt);
  }

  static String weekdaysString (BuildContext context, List<WeekdaysEnum> weekDays) {
    if(weekDays.isEmpty) return '';
    if(weekDays.length == 1) {
      return weekdayIntToString(context, weekDays[0].asInt);
    }
    if(weekDays.length > 1 && weekDays.length < 7) {
      String result = '';
      for(int i = 0; i < weekDays.length; i++) {
        result += weekdayIntToString(context, weekDays[i].asInt).substring(0, 2);
        if(i < weekDays.length - 1) result += ', ';
      }
      return result;
    }
    if(weekDays.length == 7) return context.strings.everyday;
    return '';
  }

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