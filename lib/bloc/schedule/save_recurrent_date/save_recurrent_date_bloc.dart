import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/enums/weekdays_enum.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';
import 'package:jampa_flutter/utils/forms/month_day_validator.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../utils/enums/recurrence_type_enum.dart';
import '../../../utils/helpers/alarm_helpers.dart';
import '../../../utils/helpers/notification_helpers.dart';

part 'save_recurrent_date_state.dart';
part 'save_recurrent_date_event.dart';

class SaveRecurrentDateBloc extends Bloc<SaveRecurrentDateEvent, SaveRecurrentDateState> {

  static final _initialState = SaveRecurrentDateState(
    newRecurrentDateFormElements: RecurrenceFormElements(
      selectedStartDateTime: DateTime.now(),
      selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
    ),
  );

  SaveRecurrentDateBloc() : super(_initialState) {
    on<InitializeWithData>(_initializeWithData);
    on<SelectRecurrenceType>(_selectRecurrenceType);
    on<ChangeRecurrenceDayInterval>(_changeRecurrenceDayInterval);
    on<ChangeRecurrenceYearInterval>(_changeRecurrenceYearInterval);
    on<ChangeRecurrenceMonthDate>(_changeRecurrenceMonthDate);
    on<ChangeRecurrenceWeekDays>(_changeRecurrenceWeekDays);
    on<SelectStartDateTime>(_selectStartDateTime);
    on<SelectEndDateTime>(_selectEndDateTime);
    on<SelectRecurrenceEndDateTime>(_selectRecurrenceEndDateTime);
    on<ValidateDates>(_validateDates);
    on<AddAlarmForRecurrence>(_onAddAlarm);
    on<UpdateAlarmForRecurrence>(_onUpdateAlarm);
    on<RemoveAlarmForRecurrence>(_onRemoveAlarm);
    on<DeletePersistentAlarmFromRecurrence>(_onDeletePersistentAlarm);
    on<OnSubmit>(_onSubmit);
    on<ResetState>(_resetState);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();
  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();

  void _initializeWithData(InitializeWithData event, Emitter<SaveRecurrentDateState> emit) async {
    // Prevent re-initialization on widget tree rebuild if already done
    if(state.alreadyInitialized) {
      return;
    }

    emit(state.copyWith(
      alreadyInitialized: true,
      isSavingPersistentDate: event.isSavingPersistentDate,
      newRecurrentDateFormElements: event.recurrentDateFormElements,
      initialRecurrentDateFormElementIndex: event.initialElementIndex,
      noteId: event.noteId ?? event.recurrentDateFormElements?.noteId,
      scheduleId: event.scheduleId
    ));
    // If we are editing a persistent date, we need to load its alarms from the database
    if (event.isSavingPersistentDate == true && event.initialElementIndex != null) {
      if (event.recurrentDateFormElements?.scheduleId == null) {
        throw Exception(
            "When initializing with persistent data, scheduleId must be provided in SingleDateFormElements.");
      } else {
        // Watch for alarms related to this scheduleId
        await emit.onEach(
            alarmRepository.watchAllAlarmsByScheduleId(
                event.recurrentDateFormElements!.scheduleId!),
            onData: (result) {
              RecurrenceFormElements currentElements = state
                  .newRecurrentDateFormElements.copyWith(
                  alarmsForRecurrence: result.map((alarmEntity) {
                    return alarmEntity.toAlarmFormElements();
                  }).toList()
              );
              emit(state.copyWith(
                  newRecurrentDateFormElements: currentElements));
            }
        );
      }
    }
  }

  void _selectRecurrenceType(SelectRecurrenceType event, Emitter<SaveRecurrentDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceType: event.recurrenceType
    );
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements,
    ));
  }
  
  void _changeRecurrenceDayInterval(ChangeRecurrenceDayInterval event, Emitter<SaveRecurrentDateState> emit) {
    int? interval = int.tryParse(event.interval);

    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceDaysInterval: interval
    );
    // Validate interval (>0)
    final PositiveValueValidator intervalValidator = PositiveValueValidator.dirty(interval);
    final bool isValid = Formz.validate([intervalValidator]);
    // Emit state update
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements,
      intervalDaysValidator: intervalValidator
    ));
  }
  
  void _changeRecurrenceYearInterval(ChangeRecurrenceYearInterval event, Emitter<SaveRecurrentDateState> emit) {
    int? interval = int.tryParse(event.interval);

    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceYearsInterval: interval
    );
    // Validate interval (>0)
    final PositiveValueValidator intervalValidator = PositiveValueValidator.dirty(interval);
    final bool isValid = Formz.validate([intervalValidator]);
    // Emit state update
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements,
      intervalYearsValidator: intervalValidator
    ));
  }
  
  void _changeRecurrenceMonthDate(ChangeRecurrenceMonthDate event, Emitter<SaveRecurrentDateState> emit) {
    int? day = int.tryParse(event.day);

    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceMonthDate: day
    );
    // Validate day of month (1-31)
    final MonthDayValidator monthDayValidator = MonthDayValidator.dirty(day);
    final bool isValid = Formz.validate([monthDayValidator]);
    // Emit state update
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements,
      monthDateValidator: monthDayValidator
    ));
  }
  
  void _changeRecurrenceWeekDays(ChangeRecurrenceWeekDays event, Emitter<SaveRecurrentDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceWeekdays: event.weekDays
    );
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements
    ));
  }
  
  //region Date selection and validation
  void _selectStartDateTime(SelectStartDateTime event, Emitter<SaveRecurrentDateState> emit) {
    DateTime? selectedEndDateTime = state.newRecurrentDateFormElements.selectedEndDateTime;
    // If the new start date is after the current end date, adjust the end date to be after the start date
    if(selectedEndDateTime != null && event.dateTime.isAfter(selectedEndDateTime)){
      selectedEndDateTime = event.dateTime.add(const Duration(hours: 1));
    }
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedStartDateTime: event.dateTime,
      selectedEndDateTime: selectedEndDateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _selectEndDateTime(SelectEndDateTime event, Emitter<SaveRecurrentDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedEndDateTime: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _selectRecurrenceEndDateTime(SelectRecurrenceEndDateTime event, Emitter<SaveRecurrentDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceEndDate: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _validateDates(ValidateDates event, Emitter<SaveRecurrentDateState> emit) {
    emit(state.copyWith(
      isValidEndDate: state.checkValidEndDate,
      isValidEndRecurrenceDate: state.checkRecurrenceEndDate
    ));
  }
  //endregion

  //region In-memory alarm management
  void _onAddAlarm(AddAlarmForRecurrence event, Emitter<SaveRecurrentDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newRecurrentDateFormElements.alarmsForRecurrence)
      ..add(event.alarm);
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        alarmsForRecurrence: updatedAlarms
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }

  void _onUpdateAlarm(UpdateAlarmForRecurrence event, Emitter<SaveRecurrentDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newRecurrentDateFormElements.alarmsForRecurrence);
    if(event.index >= 0 && event.index < updatedAlarms.length){
      updatedAlarms[event.index] = event.updatedAlarm;
      RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
          alarmsForRecurrence: updatedAlarms
      );
      emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    }
  }

  void _onRemoveAlarm(RemoveAlarmForRecurrence event, Emitter<SaveRecurrentDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newRecurrentDateFormElements.alarmsForRecurrence);
    if(event.index >= 0 && event.index < updatedAlarms.length){
      updatedAlarms.removeAt(event.index);
      RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
          alarmsForRecurrence: updatedAlarms
      );
      emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    }
  }
  //endregion

  void _onDeletePersistentAlarm(DeletePersistentAlarmFromRecurrence event, Emitter<SaveRecurrentDateState> emit) async {
    await alarmRepository.deleteAlarmById(event.alarmId);
  }

  void _onSubmit(OnSubmit event, Emitter<SaveRecurrentDateState> emit) async {
    if(state.isValidFormValues){
      RecurrenceFormElements newElement = state.newRecurrentDateFormElements;

      if(state.isSavingPersistentDate ?? false){
        if(state.initialRecurrentDateFormElementIndex == null){
          // Creating a new persistent date
          newElement = state.newRecurrentDateFormElements.copyWith(
            noteId: state.noteId,
            createdAt: DateTime.now()
          );
        }

        ScheduleEntity schedule = await scheduleRepository.saveRecurrenceFormElement(
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
        newRecurrentDateFormElements: newElement,
        hasSubmitted: true
      ));
    }
  }

  void _resetState(ResetState event, Emitter<SaveRecurrentDateState> emit) {
    emit(_initialState);
  }
}