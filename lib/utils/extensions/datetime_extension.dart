import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jampa_flutter/utils/extensions/strings_extension.dart';

/// Extension methods for DateTime class
extension DatetimeExtension on DateTime {

  /// Checks if the DateTime instance is between two other DateTime instances
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  /// Formats the DateTime instance to a full string representation
  /// e.g., "Monday, January 1, 2020 - 14:30"
  String toFullFormat(BuildContext context){
    String locale = Localizations.localeOf(context).languageCode;
    String dayOfWeek = DateFormat.EEEE(locale).format(this);
    String dayMonth = DateFormat.MMMMd(locale).format(this);
    String year = DateFormat.y(locale).format(this);

    return "${dayOfWeek.capitalize()}, $dayMonth, $year - $hour:${minute.toString().padLeft(2, '0')}";
  }

}