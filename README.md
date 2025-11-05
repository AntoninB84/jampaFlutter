## Inside

- SQLite database with Drift.
- GetIt for dependency injection.
- State management with Bloc/Cubit.
- Routing with GoRouter.


## l10n

If ```dart run build_runner build``` does not work, try running: ```flutter gen-l10n```

## DontKillMyApp

To ensure the app works properly in the background on certain devices (especially some Xiaomi, OnePlus, Oppo, Vivo, Realme, Huawei, Samsung models), you may need to adjust specific settings. 
Please refer to the [DontKillMyApp](https://dontkillmyapp.com/) website for detailed instructions on how to configure your device to allow the app to run in the background without being killed by the system.

Personal note:
- Options -> Apps -> Permissions -> Background autostart -> Enable for the app
- AppInfo -> Battery -> No restrictions

## Logic

The main feature is the note-taking functionality. You can create, edit, and delete notes.
Theses notes can be of different dynamic types such as basic text, event, task, or reminder...
You can also categorize notes using dynamic categories. Categories can be created, edited, and deleted.
Any note can have a date and time associated with it, which can be used for reminders or scheduling.
They can also have a recurring pattern, allowing for repeated reminders or events.
Recurrence can be of two types: interval-based (e.g., every 2 days) or specific days of the week (e.g., every Monday and Wednesday) or monthly (e.g., every 15th of the month).
Available interval units are days, weeks, months, and years.
Available recurrence periods are weekly and monthly
For interval-based recurrence, you can set a start date and an optional end date.
For day-based recurrence, you can select specific days of the week or a specific day of the month, along with a start date and an optional end date.
