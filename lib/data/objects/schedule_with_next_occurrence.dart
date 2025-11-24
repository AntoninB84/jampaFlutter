import 'package:jampa_flutter/data/models/schedule.dart';

/// Combines a [ScheduleEntity] with its next occurrence date.
class ScheduleWithNextOccurrence {
  final ScheduleEntity schedule;
  final DateTime? nextOccurrence;

  ScheduleWithNextOccurrence({
    required this.schedule,
    required this.nextOccurrence,
  });
}