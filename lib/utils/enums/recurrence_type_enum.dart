import 'package:collection/collection.dart';

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
}