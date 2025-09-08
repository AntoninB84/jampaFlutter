import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'save_single_date_state.dart';
part 'save_single_date_event.dart';

class SaveSingleDateBloc extends Bloc<SaveSingleDateEvent, SaveSingleDateState> {

  static final _initialState = SaveSingleDateState(
    newSingleDateFormElements: SingleDateFormElements(
      selectedStartDateTime: DateTime.now(),
      selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
    ),
  );

  SaveSingleDateBloc() : super(_initialState) {
    on<InitializeWithData>(_initializeWithData);
    on<SelectStartDateTime>(_selectStartDateTime);
    on<SelectEndDateTime>(_selectEndDateTime);
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
        newSingleDateFormElements: event.singleDateFormElements,
        initialSingleDateFormElementIndex: event.initialElementIndex,
        noteId: event.noteId ?? event.singleDateFormElements?.noteId,
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
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      selectedStartDateTime: event.dateTime
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

        await scheduleRepository.saveSingleDateFormElement(
            formElements: newElement,
            noteId: newElement.noteId!
        );
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