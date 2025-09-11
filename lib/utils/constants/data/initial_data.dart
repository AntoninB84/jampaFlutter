import 'package:jampa_flutter/data/models/alarm.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/enums/alarm_offset_type_enum.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';

import '../../../data/models/note.dart';

class InitialData {
  static List<CategoryEntity> categories = [
    CategoryEntity(id: null, name: "Sport", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: null, name: "Musique", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: null, name: "Projet", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: null, name: "Travail", createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  static List<NoteTypeEntity> noteTypes = [
    NoteTypeEntity(id: null, name: "Idée", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    NoteTypeEntity(id: null, name: "Reminder", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    NoteTypeEntity(id: null, name: "Event", createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  static List<NoteEntity> notes = [
    NoteEntity(
      id: 1,
      title: "First Note",
      content: "This is the content of the first note.",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    NoteEntity(
      id: 2,
      title: "Second Note",
      content: "This is the content of the second note.",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<ScheduleEntity> schedules = [
    // First note, every day for 9 days starting tomorrow
    ScheduleEntity(
      noteId: 1,
      id: 1,
      startDateTime: DateTime.now().add(const Duration(days: 1)),
      endDateTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      recurrenceEndDate: DateTime.now().add(const Duration(days: 10)),
      recurrenceType: RecurrenceType.intervalDays.name,
      recurrenceInterval: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now()
    ),
    // First note, every 18th of the month, no end date
    ScheduleEntity(
        noteId: 1,
        id: 2,
        startDateTime: DateTime.now().add(const Duration(days: 3)),
        endDateTime: DateTime.now().add(const Duration(days: 3, hours: 1)),
        recurrenceEndDate: null,
        recurrenceType: RecurrenceType.dayBasedMonthly.name,
        recurrenceDay: 18,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    // Second note, single date, 5 days from now
    ScheduleEntity(
        noteId: 2,
        id: 3,
        startDateTime: DateTime.now().add(const Duration(days: 2)),
        endDateTime: DateTime.now().add(const Duration(days: 2, hours: 1)),
        recurrenceEndDate: null,
        recurrenceType: null,
        recurrenceInterval: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
  ];

  static List<AlarmEntity> alarms = [
    AlarmEntity(
        scheduleId: 1,
        alarmOffsetType: AlarmOffsetType.hours,
        offsetValue: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    AlarmEntity(
        scheduleId: 1,
        alarmOffsetType: AlarmOffsetType.hours,
        offsetValue: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    AlarmEntity(
        scheduleId: 1,
        alarmOffsetType: AlarmOffsetType.minutes,
        offsetValue: 30,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    AlarmEntity(
        scheduleId: 2,
        alarmOffsetType: AlarmOffsetType.days,
        offsetValue: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    AlarmEntity(
        scheduleId: 3,
        alarmOffsetType: AlarmOffsetType.days,
        offsetValue: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
  ];
}