import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/reminder_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../utils/helpers/notification_helpers.dart';
import '../../utils/helpers/reminder_helpers.dart';

part 'reminder_state.dart';

/// Cubit to manage device's reminders based on schedules
class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();
  final ReminderRepository reminderRepository = serviceLocator<ReminderRepository>();

  /// Check provided schedules and set reminders accordingly
  Future<void> checkAndSetFromSchedules(List<ScheduleEntity> schedules) async {
    if(schedules.isNotEmpty){
      List<String> remindersIds = [];
      // Collecting all reminder IDs from schedules
      for(ScheduleEntity scheduleEntity in schedules){
        scheduleEntity.reminders = await reminderRepository.getAllRemindersByScheduleId(scheduleEntity.id);
        if(scheduleEntity.reminders != null && scheduleEntity.reminders!.isNotEmpty){
          for(final reminder in scheduleEntity.reminders!){
            remindersIds.add(reminder.id);
          }
        }
      }

      // Check if alarm already exists in pending notifications
      List<NotificationPayload> pendingPayloads = await NotificationHelpers.fetchPendingPayloads();
      List<NotificationPayload> alreadyScheduledList = pendingPayloads.where((payload) =>
         remindersIds.contains(payload.objectId)
      ).toList();
      // Cancel existing alarm notification if found
      for(final alreadyScheduled in alreadyScheduledList){
        await ReminderHelpers.cancelReminder(alreadyScheduled);
      }

      // Check and set alarm notifications if needed
      List<ReminderToSetup> remindersToSetup = await ReminderHelpers.calculateReminderDateFromSchedule(schedules);
      if(remindersToSetup.isNotEmpty){
        if(remindersToSetup.first.reminderDateTime.isBetween(.now(), .now().add(Duration(hours: 12)))){
          await ReminderHelpers.setReminder(remindersToSetup[0]);
        }
      }
    }
  }
}
