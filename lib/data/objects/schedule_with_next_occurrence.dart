import 'package:jampa_flutter/data/models/schedule.dart';

class ScheduleWithNextOccurrence {
  final ScheduleEntity schedule;
  final DateTime? nextOccurrence;

  ScheduleWithNextOccurrence({
    required this.schedule,
    required this.nextOccurrence,
  });
}