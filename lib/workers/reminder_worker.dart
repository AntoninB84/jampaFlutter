import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/data/dao/schedule_dao.dart';
import 'package:jampa_flutter/data/models/schedule/schedule.dart';
import 'package:jampa_flutter/utils/helpers/notification_helpers.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/helpers/reminder_helpers.dart';
import '../utils/helpers/utils.dart';
import '../utils/local_notification_manager.dart';


/// Sets up the periodic reminder worker using Workmanager
/// This worker runs every 6 hours to check for due reminders
/// and schedule notifications or alarms accordingly.
void setupReminderWorker() async {
  if(!(await Workmanager().isScheduledByUniqueName("reminder_task"))){
    await Workmanager().initialize(
        reminderWorkerCallbackDispatcher
    );
    await Workmanager().registerPeriodicTask(
      "reminder_task",
      "reminder_scheduler",
      frequency: const Duration(hours: 6),
      initialDelay: Duration(minutes: 1)
    );
    await Utils.logMessage("Periodic reminder task registered");
  }else{
    await Utils.logMessage("Reminder worker already registered");
  }
}

/// Entry point for the reminder worker.
/// This function is called by Workmanager when the worker is executed.
/// It initializes necessary components and calls the periodic reminder task.
@pragma('vm:entry-point')
void reminderWorkerCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    // Ensure Flutter bindings are initialized in the isolate
    // before using any Flutter plugins or services.
    WidgetsFlutterBinding.ensureInitialized();
    // Keeping track of execution for debugging purposes
    await Utils.logMessage("Reminder worker executing task: $task");
    switch (task) {
      case "reminder_scheduler":
        // Initialize local notifications and alarm plugins
        await LocalNotificationManager().initialize();
        await Alarm.init();
        // Execute the periodic reminder task
        await periodicReminderTask();
        break;
      default:
      // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

/// The core logic for the periodic reminder task.
/// It fetches schedules with due reminders, calculates reminder dates,
/// and sets up notifications or alarms accordingly.
Future<void> periodicReminderTask() async {

  // Fetching pending notifications and alarms to avoid duplicates
  List<NotificationPayload> pendingNotificationPayload = await NotificationHelpers.fetchPendingPayloads();

  // Fetch schedules having reminders for to-be-done notes, excluding those already scheduled
  List<ScheduleEntity> result = await ScheduleDao.getAllSchedulesHavingRemindersForToBeDoneNotes(
    remindersIdsToExclude: pendingNotificationPayload.map((e) => e.objectId).toList(),
    useNewInstanceOfDb: true
  );
  await Utils.logMessage("Fetched stuff from isolate : ${result.length} schedules found");

  // Calculate reminder dates from schedules
  List<ReminderToSetup> remindersToSetup = await ReminderHelpers.calculateReminderDateFromSchedule(result);
  await Utils.logMessage("Reminders to setup from isolate : ${remindersToSetup.length} reminders found");

  // Schedule reminders
  for(ReminderToSetup reminderToSetup in remindersToSetup) {
    await ReminderHelpers.setReminder(reminderToSetup);
  }
}