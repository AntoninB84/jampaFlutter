import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';

enum RecurrenceType {
  intervalDays,
  intervalYears,
  dayBasedWeekly,
  dayBasedMonthly;

  static RecurrenceType? fromString(String value) {
    return RecurrenceType.values.firstWhereOrNull(
            (e) => e.toString() == value
    );
  }

  String displayName(BuildContext context, {String? value}) {
    switch (this) {
      case RecurrenceType.intervalDays:
        return context.strings.recurrent_date_day_interval_display_text(value ?? "X");
      case RecurrenceType.intervalYears:
        return context.strings.recurrent_date_years_interval_display_text(value ?? 'X');
      case RecurrenceType.dayBasedWeekly:
        return context.strings.recurrent_date_weekday_display_text(value ?? "...");
      case RecurrenceType.dayBasedMonthly:
        return context.strings.recurrent_date_month_date_display_text(value ?? "X");

    }
  }
}

extension RecurrenceTypeEnumExtension on RecurrenceType? {
  bool get isIntervalDays => this == RecurrenceType.intervalDays;
  bool get isIntervalYears => this == RecurrenceType.intervalYears;
  bool get isDayBasedWeekly => this == RecurrenceType.dayBasedWeekly;
  bool get isDayBasedMonthly => this == RecurrenceType.dayBasedMonthly;
}