import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jampa_flutter/data/dao/schedule_dao.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:developer';

import '../utils/helpers/alarm_helpers.dart';
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
    await logMessage("Periodic alarm task registered");
  }else{
    await logMessage("Alarm worker already registered");
  }
}

@pragma('vm:entry-point')
void alarmWorkerCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await logMessage("Alarm worker executing task: $task");
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

Future<void> periodicAlarmTask() async {

  // Fetching pending notifications to avoid duplicates
  final pendingNotifications = await LocalNotificationManager().flutterLocalNotificationsPlugin.pendingNotificationRequests();
  List<int> pendingNotificationIds = pendingNotifications.map((e) => AlarmHelpers.extractObjectIdFromPayload(e.payload ?? "")).toList();

  // Fetch schedules having alarms for to-be-done notes, excluding those already scheduled
  List<ScheduleEntity> result = await ScheduleDao.getAllSchedulesHavingAlarmsForToBeDoneNotes(alarmIdsToExclude: pendingNotificationIds);
  await logMessage("Fetched stuff from isolate : ${result.length} schedules found");
  List<AlarmToSetup> alarmsToSetup = await AlarmHelpers.calculateAlarmDateFromSchedule(result);
  await logMessage("Alarms to setup from isolate : ${alarmsToSetup.length} alarms found");

  // Schedule alarms
  for(AlarmToSetup alarmToSetup in alarmsToSetup) {
    if(alarmToSetup.alarm.isSilent){
      // Schedule silent notification
      await logMessage("Scheduling silent notification for alarm at ${alarmToSetup.alarmDateTime} for note id ${alarmToSetup.schedule.noteId}");
      await LocalNotificationManager().scheduleNotification(
        alarmToSetup.schedule.note?.title,
        "",
        NotificationData(
          notificationType: NotificationType.reminder,
          objectId: alarmToSetup.alarm.id.toString(),
          scheduledDate: alarmToSetup.alarmDateTime
        )
      );
    }else{
      // Schedule actual alarm
      await logMessage("Scheduling alarm at ${alarmToSetup.alarmDateTime} for note id ${alarmToSetup.schedule.noteId}");
      final alarmSettings = AlarmSettings(
        id: alarmToSetup.alarm.id ?? alarmToSetup.hashCode,
        dateTime: alarmToSetup.alarmDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        androidFullScreenIntent: true,
        volumeSettings: VolumeSettings.fade(
          volume: 0.8,
          fadeDuration: Duration(seconds: 5),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: alarmToSetup.schedule.note?.title ?? 'Alarm',
          body: alarmToSetup.schedule.startDateTime?.toString() ?? '',
          stopButton: 'Stop',
        ),
      );
      await Alarm.set(alarmSettings: alarmSettings);
    }
  }
}

Future<void> logMessage(String message) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/alarm_log.txt');
  final timestamp = DateTime.now().toIso8601String();
  await file.writeAsString('$timestamp : $message\n', mode: FileMode.append);
  log(message);
}