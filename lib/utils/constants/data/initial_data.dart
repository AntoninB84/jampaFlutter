import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/enums/alarm_offset_type_enum.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/note.dart';

class InitialData {
  static final _uuid = Uuid();

  static List<String> categoryIds = List.generate(4, (_) => _uuid.v4());
  static List<String> noteTypeIds = List.generate(3, (_) => _uuid.v4());
  static List<String> noteIds = List.generate(4, (_) => _uuid.v4());
  static List<String> schedulesIds = List.generate(3, (_) => _uuid.v4());


  static List<CategoryEntity> categories = [
    CategoryEntity(id: categoryIds[0], name: "Sport", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: categoryIds[1], name: "Musique", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: categoryIds[2], name: "Projet", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    CategoryEntity(id: categoryIds[3], name: "Travail", createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];
  static List<NoteTypeEntity> noteTypes = [
    NoteTypeEntity(id: noteTypeIds[0], name: "Idée", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    NoteTypeEntity(id: noteTypeIds[1], name: "Reminder", createdAt: DateTime.now(), updatedAt: DateTime.now()),
    NoteTypeEntity(id: noteTypeIds[2], name: "Event", createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  static List<NoteEntity> notes = [
    NoteEntity(
      id: noteIds[0],
      title: "Note #1",
      content: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    NoteEntity(
      id: noteIds[1],
      title: "Note #2",
      content: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    NoteEntity(
      id: noteIds[2],
      title: "Note #3",
      content: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    NoteEntity(
      id: noteIds[3],
      title: "Note #4",
      content: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<ScheduleEntity> schedules = [
    // First note, every day for 9 days starting tomorrow
    ScheduleEntity(
      noteId: noteIds[0],
      id: schedulesIds[0],
      startDateTime: DateTime.now().add(const Duration(days: 1)),
      endDateTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
      recurrenceEndDate: DateTime.now().add(const Duration(days: 10)),
      recurrenceType: RecurrenceType.intervalDays,
      recurrenceInterval: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now()
    ),
    // First note, every 18th of the month, no end date
    ScheduleEntity(
        noteId: noteIds[0],
        id: schedulesIds[1],
        startDateTime: DateTime.now().add(const Duration(days: 3)),
        endDateTime: DateTime.now().add(const Duration(days: 3, hours: 1)),
        recurrenceEndDate: null,
        recurrenceType: RecurrenceType.dayBasedMonthly,
        recurrenceDay: 18,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    // Second note, single date, 5 days from now
    ScheduleEntity(
        noteId: noteIds[1],
        id: schedulesIds[2],
        startDateTime: DateTime.now().add(const Duration(days: 2)),
        endDateTime: DateTime.now().add(const Duration(days: 2, hours: 1)),
        recurrenceEndDate: null,
        recurrenceType: null,
        recurrenceInterval: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
  ];

  static List<ReminderEntity> alarms = [
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[0],
        offsetType: ReminderOffsetType.hours,
        offsetValue: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[0],
        offsetType: ReminderOffsetType.hours,
        offsetValue: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[0],
        offsetType: ReminderOffsetType.minutes,
        offsetValue: 30,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[1],
        offsetType: ReminderOffsetType.days,
        offsetValue: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[2],
        offsetType: ReminderOffsetType.days,
        offsetValue: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    ),
  ];
}