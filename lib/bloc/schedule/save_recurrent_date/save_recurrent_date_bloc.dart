import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../utils/enums/recurrence_type_enum.dart';

part 'save_recurrent_date_state.dart';
part 'save_recurrent_date_event.dart';

class SaveRecurrentDateBloc extends Bloc<SaveRecurrentDateEvent, SaveSingleDateState> {

  static final _initialState = SaveSingleDateState(
    newRecurrentDateFormElements: RecurrenceFormElements(
      selectedStartDateTime: DateTime.now(),
      selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
    ),
  );

  SaveRecurrentDateBloc() : super(_initialState) {
    on<InitializeWithData>(_initializeWithData);
    on<SelectStartDateTime>(_selectStartDateTime);
    on<SelectEndDateTime>(_selectEndDateTime);
    on<SelectRecurrenceEndDateTime>(_selectRecurrenceEndDateTime);
    on<ValidateDates>(_validateDates);
    on<AddAlarm>(_onAddAlarm);
    on<UpdateAlarm>(_onUpdateAlarm);
    on<RemoveAlarm>(_onRemoveAlarm);
    on<OnSubmit>(_onSubmit);
    on<ResetState>(_resetState);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();
  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();

  void _initializeWithData(InitializeWithData event, Emitter<SaveSingleDateState> emit) async {
    // Prevent re-initialization on widget tree rebuild if already done
    if(state.alreadyInitialized) return;
      emit(state.copyWith(
        alreadyInitialized: true,
        isSavingPersistentDate: event.isSavingPersistentDate,
        newRecurrentDateFormElements: event.recurrentDateFormElements,
        initialRecurrentDateFormElementIndex: event.initialElementIndex,
        noteId: event.noteId ?? event.recurrentDateFormElements?.noteId,
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

  void _selectRecurrenceType(SelectRecurrenceType event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceType: event.recurrenceType
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }
  
  void _changeRecurrenceDayInterval(ChangeRecurrenceDayInterval event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceDaysInterval: event.interval
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }
  
  void _changeRecurrenceYearInterval(ChangeRecurrenceYearInterval event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceYearsInterval: event.interval
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }
  
  void _changeRecurrenceMonthDate(ChangeRecurrenceMonthDate event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceMonthDate: event.day
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }
  
  void _changeRecurrenceWeekDays(ChangeRecurrenceWeekDays event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceWeekdays: event.weekDays
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }
  
  //region Date selection and validation
  void _selectStartDateTime(SelectStartDateTime event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedStartDateTime: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _selectEndDateTime(SelectEndDateTime event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedEndDateTime: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _selectRecurrenceEndDateTime(SelectRecurrenceEndDateTime event, Emitter<SaveSingleDateState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
      selectedRecurrenceEndDate: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDates());
  }

  void _validateDates(ValidateDates event, Emitter<SaveSingleDateState> emit) {
    emit(state.copyWith(
      isValidEndDate: state.checkValidEndDate,
      isValidEndRecurrenceDate: state.checkRecurrenceEndDate
    ));
  }
  //endregion

  //region In-memory alarm management
  void _onAddAlarm(AddAlarm event, Emitter<SaveSingleDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newRecurrentDateFormElements.alarmsForRecurrence)
      ..add(event.alarm);
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        alarmsForRecurrence: updatedAlarms
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
  }

  void _onUpdateAlarm(UpdateAlarm event, Emitter<SaveSingleDateState> emit) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newRecurrentDateFormElements.alarmsForRecurrence);
    if(event.index >= 0 && event.index < updatedAlarms.length){
      updatedAlarms[event.index] = event.updatedAlarm;
      RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
          alarmsForRecurrence: updatedAlarms
      );
      emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    }
  }

  void _onRemoveAlarm(RemoveAlarm event, Emitter<SaveSingleDateState> emit) {
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

  void _onSubmit(OnSubmit event, Emitter<SaveSingleDateState> emit) async {
    if(state.isValidDates){
      RecurrenceFormElements newElement = state.newRecurrentDateFormElements;

      if(state.isSavingPersistentDate ?? false){
        if(state.initialRecurrentDateFormElementIndex == null){
          // Creating a new persistent date
          newElement = state.newRecurrentDateFormElements.copyWith(
            noteId: state.noteId,
            createdAt: DateTime.now()
          );
        }

        await scheduleRepository.saveRecurrenceFormElement(
            formElements: newElement,
            noteId: newElement.noteId!
        );
      }

      emit(state.copyWith(
        newRecurrentDateFormElements: newElement,
        hasSubmitted: true
      ));
    }
  }

  void _resetState(ResetState event, Emitter<SaveSingleDateState> emit) {
    emit(_initialState);
  }
}