import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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

/// Bloc to manage the state of a single date schedule form.
class SingleDateFormBloc extends Bloc<SingleDateFormEvent, SingleDateFormState> {
  SingleDateFormBloc() : super(SingleDateFormState(
    newSingleDateFormElements: SingleDateFormElements(
      noteId: 'noteId',
      scheduleId: 'scheduleId',
      selectedStartDateTime: .now(),
      selectedEndDateTime: .now().add(const Duration(hours: 1)),
    ),
  )) {
    on<InitializeSingleDateFormEvent>(_initializeSingleDateForm);
    on<SelectStartDateTimeEvent>(_selectStartDateTime);
    on<SelectEndDateTimeEvent>(_selectEndDateTime);
    on<ValidateDatesEvent>(_validateDates);
    on<OnSubmitSingleDateEvent>(_onSubmitForm);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  /// Initializes the single date form with existing data if editing, or sets up for a new entry.
  void _initializeSingleDateForm(InitializeSingleDateFormEvent event, Emitter<SingleDateFormState> emit) async {
    try {
      if (event.scheduleId == null) {
        // New single date
        emit(state.copyWith(
            newSingleDateFormElements: SingleDateFormElements(
              noteId: event.noteId,
              scheduleId: Uuid().v4(),
              selectedStartDateTime: .now(),
              selectedEndDateTime: .now().add(const Duration(hours: 1)),
            )
        ));
        return;
      } else {
        // Fetching schedule from repository
        ScheduleEntity? schedule = await scheduleRepository.getScheduleById(event.scheduleId!);
        if(schedule == null) {
          // Try to retrieve from [SaveNoteBloc] if not found in repository
          SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
          schedule = dataBloc.state.singleDateSchedules.firstWhereOrNull(
                  (schedule) => schedule.id == event.scheduleId
          );
          if (schedule == null) {
            // Handle schedule not found
            debugPrint('Error initializing single date form: Schedule not found');
            return;
          }
        }
        emit(state.copyWith(
          isEditing: true,
          newSingleDateFormElements: schedule.toSingleDateFormElements()
        ));
      }
    } catch (e) {
      // Handle error
      debugPrint("Error initializing single date form: $e");
    }
  }

  /// Handles selection of start date and time.
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
    // Validate dates
    add(ValidateDatesEvent());
  }

  /// Handles selection of end date and time.
  void _selectEndDateTime(SelectEndDateTimeEvent event, Emitter<SingleDateFormState> emit) {
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
        selectedEndDateTime: event.dateTime
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
    // Validate dates
    add(ValidateDatesEvent());
  }

  /// Validates the selected start and end dates.
  void _validateDates(ValidateDatesEvent event, Emitter<SingleDateFormState> emit) {
    final isValid = state.newSingleDateFormElements.selectedStartDateTime != null &&
        state.newSingleDateFormElements.selectedEndDateTime != null &&
        state.newSingleDateFormElements.selectedStartDateTime!.isBefore(
            state.newSingleDateFormElements.selectedEndDateTime!
        );
    emit(state.copyWith(isValidDate: isValid));
  }

  /// Handles form submission by converting form elements to a [ScheduleEntity]
  /// and dispatching a save event to the [SaveNoteBloc].
  void _onSubmitForm(OnSubmitSingleDateEvent event, Emitter<SingleDateFormState> emit) {
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
    // Convert form elements to ScheduleEntity
    ScheduleEntity singleDateSchedule = ScheduleEntity.fromSingleDateFormElements(
        state.newSingleDateFormElements
    );
    // Dispatch event to save the single date schedule
    dataBloc.add(SaveSingleDateEvent(singleDateSchedule));
  }

  }
