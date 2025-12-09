import 'package:jampa_flutter/data/models/category/category.dart';
import 'package:jampa_flutter/data/models/note_type/note_type.dart';
import 'package:jampa_flutter/data/models/reminder/reminder.dart';
import 'package:jampa_flutter/data/models/schedule/schedule.dart';
import 'package:jampa_flutter/utils/enums/recurrence_type_enum.dart';
import 'package:jampa_flutter/utils/enums/reminder_offset_type_enum.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/note/note.dart';

/// This class contains initial data for categories, note types, notes, schedules, and reminders.
///
/// It generates unique IDs for each entity using the `uuid` package and provides
/// predefined lists of entities with sample data.
///
/// ONLY FOR TESTING AND DEMONSTRATION PURPOSES.
class InitialData {
  static final _uuid = Uuid();

  static List<String> categoryIds = List.generate(4, (_) => _uuid.v4());
  static List<String> noteTypeIds = List.generate(3, (_) => _uuid.v4());
  static List<String> noteIds = List.generate(4, (_) => _uuid.v4());
  static List<String> schedulesIds = List.generate(3, (_) => _uuid.v4());


  static List<CategoryEntity> categories = [
    CategoryEntity(id: categoryIds[0], name: "Sport", createdAt: .now(), updatedAt: .now()),
    CategoryEntity(id: categoryIds[1], name: "Musique", createdAt: .now(), updatedAt: .now()),
    CategoryEntity(id: categoryIds[2], name: "Projet", createdAt: .now(), updatedAt: .now()),
    CategoryEntity(id: categoryIds[3], name: "Travail", createdAt: .now(), updatedAt: .now()),
  ];
  static List<NoteTypeEntity> noteTypes = [
    NoteTypeEntity(id: noteTypeIds[0], name: "Idée", createdAt: .now(), updatedAt: .now()),
    NoteTypeEntity(id: noteTypeIds[1], name: "Reminder", createdAt: .now(), updatedAt: .now()),
    NoteTypeEntity(id: noteTypeIds[2], name: "Event", createdAt: .now(), updatedAt: .now()),
  ];

  static List<NoteEntity> notes = [
    NoteEntity(
      id: noteIds[0],
      title: "Note #1",
      content: null,
      createdAt: .now(),
      updatedAt: .now(),
    ),
    NoteEntity(
      id: noteIds[1],
      title: "Note #2",
      content: null,
      createdAt: .now(),
      updatedAt: .now(),
    ),
    NoteEntity(
      id: noteIds[2],
      title: "Note #3",
      content: null,
      createdAt: .now(),
      updatedAt: .now(),
    ),
    NoteEntity(
      id: noteIds[3],
      title: "Note #4",
      content: null,
      createdAt: .now(),
      updatedAt: .now(),
    ),
  ];

  static List<ScheduleEntity> schedules = [
    // First note, every day for 9 days starting tomorrow
    ScheduleEntity(
      noteId: noteIds[0],
      id: schedulesIds[0],
      startDateTime: .now().add(const Duration(days: 1)),
      endDateTime: .now().add(const Duration(days: 1, hours: 1)),
      recurrenceEndDate: .now().add(const Duration(days: 10)),
      recurrenceType: .intervalDays,
      recurrenceInterval: 1,
      createdAt: .now(),
      updatedAt: .now()
    ),
    // First note, every 18th of the month, no end date
    ScheduleEntity(
        noteId: noteIds[0],
        id: schedulesIds[1],
        startDateTime: .now().add(const Duration(days: 3)),
        endDateTime: .now().add(const Duration(days: 3, hours: 1)),
        recurrenceEndDate: null,
        recurrenceType: .dayBasedMonthly,
        recurrenceDay: 18,
        createdAt: .now(),
        updatedAt: .now()
    ),
    // Second note, single date, 5 days from now
    ScheduleEntity(
        noteId: noteIds[1],
        id: schedulesIds[2],
        startDateTime: .now().add(const Duration(days: 2)),
        endDateTime: .now().add(const Duration(days: 2, hours: 1)),
        recurrenceEndDate: null,
        recurrenceType: null,
        recurrenceInterval: null,
        createdAt: .now(),
        updatedAt: .now()
    ),
  ];

  static List<ReminderEntity> alarms = [
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[0],
        noteId: noteIds[0],
        offsetType: .hours,
        offsetValue: 2,
        createdAt: .now(),
        updatedAt: .now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[0],
        noteId: noteIds[0],
        offsetType: .hours,
        offsetValue: 1,
        createdAt: .now(),
        updatedAt: .now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[0],
        noteId: noteIds[0],
        offsetType: .minutes,
        offsetValue: 30,
        createdAt: .now(),
        updatedAt: .now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[1],
        noteId: noteIds[0],
        offsetType: .days,
        offsetValue: 2,
        createdAt: .now(),
        updatedAt: .now()
    ),
    ReminderEntity(
        id: _uuid.v4(),
        scheduleId: schedulesIds[2],
        noteId: noteIds[1],
        offsetType: .days,
        offsetValue: 1,
        createdAt: .now(),
        updatedAt: .now()
    ),
  ];
}