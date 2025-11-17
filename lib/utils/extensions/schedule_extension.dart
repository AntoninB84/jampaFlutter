import 'package:jampa_flutter/data/models/schedule.dart';

import '../enums/recurrence_type_enum.dart';

extension ScheduleExtension on ScheduleEntity {
  bool get isRecurring {
    return recurrenceType != null;
  }

  /* Returns the next occurrence DateTime of the schedule after the given `after` DateTime.
   * If `after` is null, uses current DateTime.
   * Returns null if there are no more occurrences.
   */
  DateTime? nextOccurrence(DateTime? after) {
    final now = DateTime.now();
    after = after ?? now;

    final DateTime? start = startDateTime;
    if (start == null) return null;

    // Helper: combine a date (y/m/d) with the time part of `start`
    DateTime combineDateWithStartTime(DateTime date) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        start.hour,
        start.minute,
        start.second,
        start.millisecond,
        start.microsecond,
      );
    }

    // If the schedule is not recurring, return the start if it's >= after
    if (recurrenceType == null) {
      final DateTime candidate = combineDateWithStartTime(start);
      return !candidate.isBefore(after) ? candidate : null;
    }

    // Respect recurrence end date if present
    bool isAfterEnd(DateTime candidate) {
      if (recurrenceEndDate == null) return false;
      // end date likely stored as date/time; allow occurrences on the same day as end date
      final end = recurrenceEndDate!;
      return candidate.isAfter(end);
    }

    switch (recurrenceType) {
      case RecurrenceType.intervalDays: {
        final int interval = (recurrenceInterval ?? 1).clamp(1, 1000000);
        // If start is in the future and >= after, return it
        DateTime candidate = combineDateWithStartTime(start);
        if (!candidate.isBefore(after)) {
          return isAfterEnd(candidate) ? null : candidate;
        }

        // Compute number of whole intervals from start to 'after'
        final daysSinceStart = after.difference(start).inDays;
        int cycles = (daysSinceStart / interval).ceil();
        if (cycles < 0) cycles = 0;
        candidate = combineDateWithStartTime(start.add(Duration(days: cycles * interval)));
        // If candidate still before `after`, advance one more interval
        if (candidate.isBefore(after)) {
          candidate = combineDateWithStartTime(candidate.add(Duration(days: interval)));
        }
        return isAfterEnd(candidate) ? null : candidate;
      }

      case RecurrenceType.intervalYears: {
        final int interval = (recurrenceInterval ?? 1).clamp(1, 1000000);
        DateTime candidate = combineDateWithStartTime(start);
        if (!candidate.isBefore(after)) {
          return isAfterEnd(candidate) ? null : candidate;
        }

        int yearsSince = after.year - start.year;
        int cycles = (yearsSince / interval).ceil();
        if (cycles < 0) cycles = 0;
        candidate = DateTime(
          start.year + cycles * interval,
          start.month,
          start.day,
          start.hour,
          start.minute,
          start.second,
          start.millisecond,
          start.microsecond,
        );
        // If Dart created an invalid date (e.g. Feb 29 -> Mar 1), it's acceptable here.
        if (candidate.isBefore(after)) {
          candidate = DateTime(
            candidate.year + interval,
            start.month,
            start.day,
            start.hour,
            start.minute,
            start.second,
            start.millisecond,
            start.microsecond,
          );
        }
        return isAfterEnd(candidate) ? null : candidate;
      }

      case RecurrenceType.dayBasedWeekly: {
        // recurrenceDay is stored as concatenated digits like 135 -> [1,3,5]
        if (recurrenceDay == null) return null;
        final String digits = recurrenceDay.toString();
        final Set<int> weekdays = digits
            .split('')
            .where((d) => d.isNotEmpty)
            .map((d) => int.tryParse(d) ?? -1)
            .where((v) => v >= 1 && v <= 7) // assume WeekdaysEnum uses 1..7 matching DateTime.weekday
            .toSet();
        if (weekdays.isEmpty) return null;

        // Start searching from `after` (inclusive) up to next 7 days
        for (int add = 0; add < 14; add++) { // search up to two weeks to be safe with time-of-day
          final DateTime probeDate = after.add(Duration(days: add));
          final DateTime candidate = combineDateWithStartTime(probeDate);
          final int weekday = candidate.weekday; // 1..7
          if (weekdays.contains(weekday) && !candidate.isBefore(after)) {
            return isAfterEnd(candidate) ? null : candidate;
          }
        }
        return null;
      }

      case RecurrenceType.dayBasedMonthly: {
        if (recurrenceDay == null) return null;
        final int dayOfMonth = recurrenceDay!;
        if (dayOfMonth < 1 || dayOfMonth > 31) return null;

        // If start in future and matches the day, return it
        DateTime candidate = combineDateWithStartTime(start);
        if (!candidate.isBefore(after) && candidate.day == dayOfMonth) {
          return isAfterEnd(candidate) ? null : candidate;
        }

        // Try month by month until we find a valid date >= after
        DateTime probe = DateTime(after.year, after.month, 1);
        for (int i = 0; i < 1200; i++) { // avoid infinite loop; search up to 100 years
          final int year = probe.year + ((probe.month - 1 + i) ~/ 12);
          final int month = ((probe.month - 1 + i) % 12) + 1;
          // If the target month doesn't have `dayOfMonth` (e.g., Feb 30), skip
          DateTime maybe;
          try {
            maybe = DateTime(year, month, dayOfMonth, start.hour, start.minute, start.second,
                start.millisecond, start.microsecond);
          } catch (_) {
            continue;
          }
          if (!maybe.isBefore(after)) {
            return isAfterEnd(maybe) ? null : maybe;
          }
        }
        return null;
      }

      default:
        return null;
    }
  }
}