import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/data/dao/schedule_dao.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/helpers/notification_helpers.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/helpers/reminder_helpers.dart';
import '../utils/helpers/utils.dart';
import '../utils/local_notification_manager.dart';

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

@pragma('vm:entry-point')
void reminderWorkerCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Utils.logMessage("Reminder worker executing task: $task");
    switch (task) {
      case "reminder_scheduler":
        await LocalNotificationManager().initialize();
        await Alarm.init();
        await periodicReminderTask();
        break;
      default:
      // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

Future<void> periodicReminderTask({
  bool useNewInstanceOfDb = true,
}) async {

  // Fetching pending notifications and alarms to avoid duplicates
  List<NotificationPayload> pendingNotificationPayload = await NotificationHelpers.fetchPendingPayloads();

  // Fetch schedules having reminders for to-be-done notes, excluding those already scheduled
  List<ScheduleEntity> result = await ScheduleDao.getAllSchedulesHavingRemindersForToBeDoneNotes(
    remindersIdsToExclude: pendingNotificationPayload.map((e) => e.objectId).toList(),
    useNewInstanceOfDb: useNewInstanceOfDb
  );
  await Utils.logMessage("Fetched stuff from isolate : ${result.length} schedules found");
  List<ReminderToSetup> remindersToSetup = await ReminderHelpers.calculateReminderDateFromSchedule(result);
  await Utils.logMessage("Reminders to setup from isolate : ${remindersToSetup.length} reminders found");

  // Schedule reminders
  for(ReminderToSetup reminderToSetup in remindersToSetup) {
    await ReminderHelpers.setReminder(reminderToSetup);
  }
}