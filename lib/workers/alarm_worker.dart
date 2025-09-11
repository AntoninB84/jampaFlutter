import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/data/dao/schedule_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:developer';

import '../utils/helpers/alarm_helpers.dart';

void setupAlarmWorker() async {
  if(!(await Workmanager().isScheduledByUniqueName("alarm_task"))){
    Workmanager().initialize(
        alarmWorkerCallbackDispatcher
    );
    Workmanager().registerPeriodicTask(
      "alarm_task",
      "alarm_scheduler",
      frequency: const Duration(hours: 1),
      initialDelay: Duration(minutes: 1)
    );
    await logSomething("Periodic alarm task registered");
  }else{
    await logSomething("Alarm worker already registered");
  }
}

@pragma('vm:entry-point')
void alarmWorkerCallbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await logSomething("Alarm worker executing task: $task");
    switch (task) {
      case "alarm_scheduler":
        // Call your alarm scheduling function here
        await testAlarmTask();
        break;
      default:
      // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}

Future<void> testAlarmTask() async {
  await logSomething("Setting up service locator in alarm task");
  final result = await ScheduleDao.getAllSchedulesHavingAlarmsForToBeDoneNotes();
  await logSomething("Fetched stuff from isolate : ${result.length} schedules found");
  final alarmsToSetup = await AlarmHelpers.calculateAlarmDateFromSchedule(result);
  await logSomething("Alarms to setup from isolate : ${alarmsToSetup.length} alarms found");

  //TODO: Actually set up the alarms

  // NoteEntity note = NoteEntity(
  //   title: "Test Note",
  //   content: "This is a test note",
  //   createdAt: DateTime.now(),
  //   updatedAt: DateTime.now(),
  // );
  // await NoteDao.insertNoteFromIsolate(note);
}

Future<void> logSomething(String message) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/alarm_log.txt');
  final timestamp = DateTime.now().toIso8601String();
  await file.writeAsString('$timestamp : $message\n', mode: FileMode.append);
  log(message);
  print(message);
}