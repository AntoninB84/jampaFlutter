import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jampa_flutter/utils/extensions/strings_extension.dart';

extension DatetimeExtension on DateTime {
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  String toFullFormat(BuildContext context){
    String locale = Localizations.localeOf(context).languageCode;
    String dayOfWeek = DateFormat.EEEE(locale).format(this);
    String dayMonth = DateFormat.MMMMd(locale).format(this);
    String year = DateFormat.y(locale).format(this);

    return "${dayOfWeek.capitalize()}, $dayMonth, $year - $hour:${minute.toString().padLeft(2, '0')}";
  }

}