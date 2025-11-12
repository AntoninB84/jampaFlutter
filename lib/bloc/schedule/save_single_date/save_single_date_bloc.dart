import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../utils/helpers/alarm_helpers.dart';
import '../../../utils/helpers/notification_helpers.dart';

part 'save_single_date_state.dart';
part 'save_single_date_event.dart';

class SaveSingleDateBloc extends Bloc<SaveSingleDateEvent, SaveSingleDateState> {

  static final SingleDateFormElements emptySingleDateFormElements = SingleDateFormElements(
    selectedStartDateTime: DateTime.now(),
    selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
    alarmsForSingleDate: [],
  );
  static final _initialState = SaveSingleDateState(
    newSingleDateFormElements: emptySingleDateFormElements,
  );

  SaveSingleDateBloc() : super(_initialState) {
    on<InitializeWithData>(_initializeWithData);
    on<SelectStartDateTime>(_selectStartDateTime);
    on<SelectEndDateTime>(_selectEndDateTime);
    on<ValidateDates>(_validateDates);
    on<AddAlarm>(_onAddAlarm);
    on<UpdateAlarm>(_onUpdateAlarm);
    on<RemoveAlarm>(_onRemoveAlarm);
    on<DeletePersistentAlarmFromSingleDate>(_onDeletePersistentAlarm);
    on<OnSubmit>(_onSubmit);
    on<ResetState>(_resetState);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();
  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();

  void _initializeWithData(InitializeWithData event, Emitter<SaveSingleDateState> emit) async {
    // Prevent re-initialization on widget tree rebuild if already done
    if(state.alreadyInitialized) {
      return;
    }

    emit(state.copyWith(
      alreadyInitialized: true,
      isSavingPersistentDate: event.isSavingPersistentDate,
      newSingleDateFormElements: event.singleDateFormElements,
      initialSingleDateFormElementIndex: event.initialElementIndex,
      noteId: event.noteId ?? event.singleDateFormElements?.noteId,
      scheduleId: event.scheduleId
    ));
    // If we are editing a persistent date, we need to load its alarms from the database
    if (event.isSavingPersistentDate == true && event.initialElementIndex != null) {
      if (event.singleDateFormElements?.scheduleId == null) {
        throw Exception(
            "When initializing with persistent data, scheduleId must be provided in SingleDateFormElements.");
      } else {
        // Watch for alarms related to this scheduleId
        await emit.onEach(
            alarmRepository.watchAllAlarmsByScheduleId(
                event.singleDateFormElements!.scheduleId!),
            onData: (result) {
              SingleDateFormElements currentElements = state
                  .newSingleDateFormElements.copyWith(
                  alarmsForSingleDate: result.map((alarmEntity) {
                    return alarmEntity.toAlarmFormElements();
                  }).toList()
              );
              emit(state.copyWith(
                  newSingleDateFormElements: currentElements));
            }
        );
      }
    }
  }

  void _selectStartDateTime(SelectStartDateTime event, Emitter<SaveSingleDateState> emit) {
    DateTime? selectedEndDateTime = state.newSingleDateFormElements.selectedEndDateTime;
    // If the new start date is after the current end date, adjust the end date to be after the start date
    if(selectedEndDateTime != null && event.dateTime.isAfter(selectedEndDateTime)){
      selectedEndDateTime = event.dateTime.add(const Duration(hours: 1));
    }

    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      selectedStartDateTime: event.dateTime,
      selectedEndDateTime: selectedEndDateTime
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _selectEndDateTime(SelectEndDateTime event, Emitter<SaveSingleDateState> emit) {
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      selectedEndDateTime: event.dateTime
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _validateDates(ValidateDates event, Emitter<SaveSingleDateState> emit) {
    final isValid = state.newSingleDateFormElements.selectedStartDateTime != null &&
        state.newSingleDateFormElements.selectedEndDateTime != null &&
        state.newSingleDateFormElements.selectedStartDateTime!.isBefore(
            state.newSingleDateFormElements.selectedEndDateTime!
        );
    emit(state.copyWith(isValidDate: isValid));
  }

  //region In-memory alarm management
  void _onAddAlarm(AddAlarm event, Emitter<SaveSingleDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newSingleDateFormElements.alarmsForSingleDate)
      ..add(event.alarm);
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      alarmsForSingleDate: updatedAlarms
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
  }

  void _onUpdateAlarm(UpdateAlarm event, Emitter<SaveSingleDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newSingleDateFormElements.alarmsForSingleDate);
    if(event.index >= 0 && event.index < updatedAlarms.length){
      updatedAlarms[event.index] = event.updatedAlarm;
      SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
        alarmsForSingleDate: updatedAlarms
      );
      emit(state.copyWith(newSingleDateFormElements: currentElements));
    }
  }

  void _onRemoveAlarm(RemoveAlarm event, Emitter<SaveSingleDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newSingleDateFormElements.alarmsForSingleDate);
    if(event.index >= 0 && event.index < updatedAlarms.length){
      updatedAlarms.removeAt(event.index);
      SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
        alarmsForSingleDate: updatedAlarms
      );
      emit(state.copyWith(newSingleDateFormElements: currentElements));
    }
  }
  //endregion

  void _onDeletePersistentAlarm(DeletePersistentAlarmFromSingleDate event, Emitter<SaveSingleDateState> emit) async {
    await alarmRepository.deleteAlarmById(event.alarmId);
  }

  void _onSubmit(OnSubmit event, Emitter<SaveSingleDateState> emit) async {
    if(state.isValidDate){
      SingleDateFormElements newElement = state.newSingleDateFormElements;

      if(state.isSavingPersistentDate ?? false){
        if(state.initialSingleDateFormElementIndex == null){
          // Creating a new persistent date
          newElement = state.newSingleDateFormElements.copyWith(
            noteId: state.noteId,
            createdAt: DateTime.now()
          );
        }

        ScheduleEntity schedule = await scheduleRepository.saveSingleDateFormElement(
            formElements: newElement,
            noteId: newElement.noteId!
        );

        schedule.alarms = await alarmRepository.getAllAlarmsByScheduleId(schedule.id!);
        List<int> scheduledAlarmsIds = schedule.alarms?.map((alarm) => alarm.id!).toList() ?? [];
        // Check if alarm already exists in pending notifications
        List<NotificationPayload> pendingPayloads = await NotificationHelpers.fetchPendingPayloads();
        List<NotificationPayload> alreadyScheduledList = pendingPayloads.where((payload) =>
            scheduledAlarmsIds.contains(payload.objectId)
        ).toList();
        // Cancel existing alarm notification if found
        for(final alreadyScheduled in alreadyScheduledList){
          await AlarmHelpers.cancelAlarmNotification(alreadyScheduled);
        }

        // Check and set alarm notifications if needed
        List<AlarmToSetup> alarmsToSetup = await AlarmHelpers.calculateAlarmDateFromSchedule([schedule]);
        if(alarmsToSetup.isNotEmpty){
          if(alarmsToSetup.first.alarmDateTime.isBetween(DateTime.now(), DateTime.now().add(Duration(hours: 12)))){
            await AlarmHelpers.setAlarmNotification(alarmsToSetup[0]);
          }
        }
      }
      
      emit(state.copyWith(
        newSingleDateFormElements: newElement,
        hasSubmitted: true
      ));
    }
  }

  void _resetState(ResetState event, Emitter<SaveSingleDateState> emit) {
    emit(_initialState);
  }
}