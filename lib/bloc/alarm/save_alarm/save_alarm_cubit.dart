import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';
import 'package:jampa_flutter/utils/helpers/alarm_helpers.dart';
import 'package:jampa_flutter/utils/helpers/notification_helpers.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../data/models/alarm.dart';
import '../../../repository/schedule_repository.dart';
import '../../../utils/enums/alarm_offset_type_enum.dart';
import '../../notes/create/create_note_form_helpers.dart';

part 'save_alarm_state.dart';

class SaveAlarmCubit extends Cubit<SaveAlarmState> {
  SaveAlarmCubit({
    bool? isSavingPersistentAlarm,
    int? scheduleId,
  }) : super(SaveAlarmState(
    scheduleId: scheduleId,
    isSavingPersistentAlarm: isSavingPersistentAlarm ?? false,
    newAlarmFormElements: AlarmFormElements(
      selectedOffsetNumber: 10,
      selectedOffsetType: AlarmOffsetType.minutes,
      isSilentAlarm: true
    ),
  ));

  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void initializeWithData({
    AlarmFormElements? alarmFormElements,
    int? initialElementIndex,
    bool isSavingPersistentAlarm = false,
  }) {
    if (alarmFormElements != null) {
      emit(state.copyWith(
        isSavingPersistentAlarm: isSavingPersistentAlarm,
        initialAlarmFormElementIndex: initialElementIndex,
        newAlarmFormElements: alarmFormElements,
      ));
      selectOffsetNumber(alarmFormElements.selectedOffsetNumber.toString());
    } else {
      throw Exception("AlarmFormElements must be provided when initializing with data.");
    }
  }

  void selectOffsetNumber(String value) {
    final parsedNumber = int.tryParse(value) ?? 0;
    final number = PositiveValueValidator.dirty(parsedNumber);

    AlarmFormElements currentElements = state.newAlarmFormElements.copyWith(
      selectedOffsetNumber: number.value
    );
    emit(state.copyWith(
      newAlarmFormElements: currentElements,
      offsetNumberValidator: number,
      isValidOffsetNumber: Formz.validate([number])
    ));
    _validateForm();
  }

  void selectOffsetType(AlarmOffsetType? type) {
    AlarmFormElements currentElements = state.newAlarmFormElements.copyWith(
      selectedOffsetType: type
    );
    emit(state.copyWith(newAlarmFormElements: currentElements));
    _validateForm();
  }

  void toggleSilentAlarm(bool? isSilent) {
    AlarmFormElements currentElements = state.newAlarmFormElements.copyWith(
      isSilentAlarm: isSilent ?? true
    );
    emit(state.copyWith(newAlarmFormElements: currentElements));
  }

  void _validateForm() {
    final isValid = state.newAlarmFormElements.selectedOffsetNumber > 0;
    emit(state.copyWith(isValidAlarm: isValid));
  }

  void onSubmit() async {
    if (state.isValidAlarm) {
      AlarmFormElements newElement = state.newAlarmFormElements;

      if(state.isSavingPersistentAlarm ?? false){
        if(state.initialAlarmFormElementIndex == null){
          // Creating a new persistent alarm
          newElement = state.newAlarmFormElements.copyWith(
            scheduleId: state.scheduleId ?? state.newAlarmFormElements.scheduleId,
            createdAt: DateTime.now(),
          );
        }
        // Save the persistent alarm
        AlarmEntity newAlarm = await alarmRepository.saveAlarmFormElement(
            formElements: newElement,
            scheduleId: newElement.scheduleId!
        );

        // Check and set an alarm notification if needed
        ScheduleEntity? parentSchedule = await scheduleRepository.getScheduleById(newElement.scheduleId!);
        if(parentSchedule != null){
          // Set the alarm as the schedule's alarms
          parentSchedule.alarms = [newAlarm];

          // Check if alarm already exists in pending notifications
          List<NotificationPayload> pendingPayloads = await NotificationHelpers.fetchPendingPayloads();
          NotificationPayload? alreadyScheduled = pendingPayloads.firstWhereOrNull((payload) => payload.objectId == newAlarm.id);
          // Cancel existing alarm notification if found
          if(alreadyScheduled != null){
            await AlarmHelpers.cancelAlarmNotification(alreadyScheduled);
          }

          // Calculate the alarm notification datetime
          List<AlarmToSetup> alarmsToSetup = await AlarmHelpers.calculateAlarmDateFromSchedule([parentSchedule]);
          if(alarmsToSetup.isNotEmpty){
            if(alarmsToSetup.first.alarmDateTime.isBetween(DateTime.now(), DateTime.now().add(Duration(hours: 12)))){
              // Set the new alarm notification
              await AlarmHelpers.setAlarmNotification(alarmsToSetup[0]);
            }
          }
        }
      }

      emit(state.copyWith(
          newAlarmFormElements: newElement,
          hasSubmitted: true
      ));
    }
  }
}