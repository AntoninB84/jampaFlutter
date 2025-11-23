## Introduction

This is a Flutter application that serves as a note-taking tool with advanced features such as dynamic note types, categories and reminders with recurrence options.
The app is built using various packages and is trying to follow best practices for state management, dependency injection, and database handling.

**Database** : SQLite with Drift  
**Dependency Injection** : GetIt  
**State Management** : Bloc/Cubit  
**Routing** : GoRouter
**Localization** : Flutter's l10n
Incoming tools: Freezed, unit/integration testing

## l10n

If ```dart run build_runner build``` does not work, try running: ```flutter gen-l10n```

## DontKillMyApp

To ensure the app works properly in the background on certain devices (especially some Xiaomi, OnePlus, Oppo, Vivo, Realme, Huawei, Samsung models), you may need to adjust specific settings. 
Please refer to the [DontKillMyApp](https://dontkillmyapp.com/) website for detailed instructions on how to configure your device to allow the app to run in the background without being killed by the system.

Personal note:
- Options -> Apps -> Permissions -> Background autostart -> Enable for the app
- AppInfo -> Battery -> No restrictions

## Recurring reminders
 The schedule class has the following properties:
 - startDateTime: DateTime
 - endDateTime: DateTime?
 - recurrenceEndDate: DateTime?
 - recurrenceInterval: int?
 - recurrenceType: [RecurrenceType]?
 - recurrenceDay: int?

[RecurrenceType](lib/utils/enums/recurrence_type_enum.dart) can be:
 - intervalDays (every n days)
 - dayBasedWeekly (on one or more days of the week)
 - dayBasedMonthly (on a specific day of the month)
 - intervalYears (every n years on a specific month and day)

Example schedules:
 - Reminder on a specific date (not recurring)
   - startDateTime: DateTime
   - endDateTime: DateTime?
   - recurrenceEndDate: null
   - recurrenceInterval: null
   - recurrenceType: null
   - recurrenceDay: null
 - Reminder every 3 days
   - startDateTime: DateTime
   - endDateTime: DateTime?
   - recurrenceEndDate: DateTime?
   - recurrenceInterval: 3
   - recurrenceType: intervalDays
   - recurrenceDay: null
 - Reminder every week on Monday, Wednesday, and Friday
   - startDateTime: DateTime
   - endDateTime: DateTime?
   - recurrenceEndDate: DateTime?
   - recurrenceInterval: null
   - recurrenceType: dayBasedWeekly
   - recurrenceDay: 135 (1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun)
 - Reminder every month on the 15th
   - startDateTime: DateTime
   - endDateTime: DateTime?
   - recurrenceEndDate: DateTime?
   - recurrenceInterval: null
   - recurrenceType: dayBasedMonthly
   - recurrenceDay: 15
 - Reminder every 2 years on (DateTime)
   - startDateTime: DateTime
   - endDateTime: DateTime?
   - recurrenceEndDate: DateTime?
   - recurrenceInterval: 2
   - recurrenceType: intervalYears
   - recurrenceDay: null