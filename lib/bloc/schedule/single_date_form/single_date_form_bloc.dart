import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:uuid/uuid.dart';

import '../../../repository/schedule_repository.dart';
import '../../../utils/service_locator.dart';
import '../../notes/form/note_form_helpers.dart';

part 'single_date_form_event.dart';
part 'single_date_form_state.dart';

class SingleDateFormBloc extends Bloc<SingleDateFormEvent, SingleDateFormState> {
  SingleDateFormBloc() : super(SingleDateFormState(
    newSingleDateFormElements: SingleDateFormElements(
      noteId: 'noteId',
      scheduleId: Uuid().v4(),
      selectedStartDateTime: DateTime.now(),
      selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
    ),
  )) {
    on<InitializeSingleDateFormEvent>(_initializeSingleDateForm);
    on<SelectStartDateTimeEvent>(_selectStartDateTime);
    on<SelectEndDateTimeEvent>(_selectEndDateTime);
    on<ValidateDatesEvent>(_validateDates);
    on<OnSubmitSingleDateEvent>(_onSubmitForm);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void _initializeSingleDateForm(InitializeSingleDateFormEvent event, Emitter<SingleDateFormState> emit) async {
    try {
      if (event.scheduleId == null) {
        // New single date
        emit(state.copyWith(
            isSavingPersistentData: event.isSavingPersistentData,
            newSingleDateFormElements: SingleDateFormElements(
              noteId: event.noteId,
              scheduleId: Uuid().v4(),
              selectedStartDateTime: DateTime.now(),
              selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
            )
        ));
        return;
      } else {
        // Editing existing single date
        final schedule = await scheduleRepository.getScheduleById(event.scheduleId!);
        if (schedule == null) {
          emit(state.copyWith()); //TODO
          return;
        }
        emit(state.copyWith(
            isSavingPersistentData: event.isSavingPersistentData,
            newSingleDateFormElements: schedule.toSingleDateFormElements()
        ));
      }
    } catch (e) {
      // Handle error
      debugPrint("Error initializing single date form: $e");
    }
  }

    void _selectStartDateTime(SelectStartDateTimeEvent event, Emitter<SingleDateFormState> emit) {
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
      add(ValidateDatesEvent());
    }

    void _selectEndDateTime(SelectEndDateTimeEvent event, Emitter<SingleDateFormState> emit) {
      SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
          selectedEndDateTime: event.dateTime
      );
      emit(state.copyWith(newSingleDateFormElements: currentElements));
      add(ValidateDatesEvent());
    }

    void _validateDates(ValidateDatesEvent event, Emitter<SingleDateFormState> emit) {
      final isValid = state.newSingleDateFormElements.selectedStartDateTime != null &&
          state.newSingleDateFormElements.selectedEndDateTime != null &&
          state.newSingleDateFormElements.selectedStartDateTime!.isBefore(
              state.newSingleDateFormElements.selectedEndDateTime!
          );
      emit(state.copyWith(isValidDate: isValid));
    }

    void _onSubmitForm(OnSubmitSingleDateEvent event, Emitter<SingleDateFormState> emit) {
      //TODO loading state
      SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
      if(state.isSavingPersistentData){
        // Save to persistent storage
        ScheduleEntity singleDateSchedule = ScheduleEntity.fromSingleDateFormElements(
            state.newSingleDateFormElements
        );
        dataBloc.add(SaveSingleDateEvent(singleDateSchedule));
      } else {
        List<ScheduleEntity> singleDates = dataBloc.state.singleDateSchedules;
        ScheduleEntity singleDateSchedule = ScheduleEntity.fromSingleDateFormElements(
            state.newSingleDateFormElements
        );

        if(singleDates.isNotEmpty &&
            singleDates.any((element)
            => element.id == singleDateSchedule.id)) {
          // This is the edit of a non persistent schedule ->
          // Update the schedule in the SaveNoteBloc
          dataBloc.add(UpdateSingleDateEvent(singleDateSchedule));
        } else {
          // This is the creation of a non persistent schedule ->
          // Just add the schedule to the SaveNoteBloc
          dataBloc.add(AddSingleDateEvent(singleDateSchedule));
        }
      }
      //TODO emit success state
    }

  }
