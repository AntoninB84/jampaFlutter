import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/data/dao/schedule_dao.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/utils/helpers/notification_helpers.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/helpers/alarm_helpers.dart';
import '../utils/helpers/utils.dart';
import '../utils/local_notification_manager.dart';

void setupAlarmWorker() async {
  if(!(await Workmanager().isScheduledByUniqueName("alarm_task"))){
    await Workmanager().initialize(
        alarmWorkerCallbackDispatcher
    );
    await Workmanager().registerPeriodicTask(
      "alarm_task",
      "alarm_scheduler",
      frequency: const Duration(hours: 6),
      initialDelay: Duration(minutes: 1)
    );
    await Utils.logMessage("Periodic alarm task registered");
  }else{
    await Utils.logMessage("Alarm worker already registered");
  }
}

@pragma('vm:entry-point')
void alarmWorkerCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Utils.logMessage("Alarm worker executing task: $task");
    switch (task) {
      case "alarm_scheduler":
        await LocalNotificationManager().initialize();
        await Alarm.init();
        await periodicAlarmTask();
        break;
      default:
      // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

Future<void> periodicAlarmTask({
  bool useNewInstanceOfDb = true,
}) async {

  // Fetching pending notifications to avoid duplicates
  List<NotificationPayload> pendingNotificationPayload = await NotificationHelpers.fetchPendingPayloads();

  // Fetch schedules having alarms for to-be-done notes, excluding those already scheduled
  List<ScheduleEntity> result = await ScheduleDao.getAllSchedulesHavingAlarmsForToBeDoneNotes(
    alarmIdsToExclude: pendingNotificationPayload.map((e) => e.objectId).toList(),
    useNewInstanceOfDb: useNewInstanceOfDb
  );
  await Utils.logMessage("Fetched stuff from isolate : ${result.length} schedules found");
  List<AlarmToSetup> alarmsToSetup = await AlarmHelpers.calculateAlarmDateFromSchedule(result);
  await Utils.logMessage("Alarms to setup from isolate : ${alarmsToSetup.length} alarms found");

  // Schedule alarms
  for(AlarmToSetup alarmToSetup in alarmsToSetup) {
    await AlarmHelpers.setAlarmNotification(alarmToSetup);
  }
}