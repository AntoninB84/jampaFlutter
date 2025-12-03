import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/schedule/schedule.dart';
import 'package:uuid/uuid.dart';

import '../../../repository/schedule_repository.dart';
import '../../../utils/enums/recurrence_type_enum.dart';
import '../../../utils/enums/weekdays_enum.dart';
import '../../../utils/forms/month_day_validator.dart';
import '../../../utils/forms/positive_number_validator.dart';
import '../../../utils/service_locator.dart';
import '../../notes/form/note_form_helpers.dart';
import '../../notes/save/save_note_bloc.dart';

part 'recurrent_date_form_event.dart';
part 'recurrent_date_form_state.dart';

/// Bloc to manage the state of the recurrent date schedule form
class RecurrentDateFormBloc extends Bloc<RecurrentDateFormEvent, RecurrentDateFormState> {
  RecurrentDateFormBloc() : super(RecurrentDateFormState(
      newRecurrentDateFormElements: RecurrenceFormElements(
        noteId: 'noteId',
        scheduleId: 'scheduleId',
        selectedStartDateTime: .now(),
        selectedEndDateTime: .now().add(const Duration(hours: 1)),
      ),
  )) {
    on<InitializeRecurrentDateFormEvent>(_initializeRecurrentDateForm);
    on<SelectRecurrenceTypeEvent>(_selectRecurrenceType);
    on<ChangeRecurrenceDayIntervalEvent>(_changeRecurrenceDayInterval);
    on<ChangeRecurrenceYearIntervalEvent>(_changeRecurrenceYearInterval);
    on<ChangeRecurrenceMonthDateEvent>(_changeRecurrenceMonthDate);
    on<ChangeRecurrenceWeekDaysEvent>(_changeRecurrenceWeekDays);
    on<SelectStartDateTimeEvent>(_selectStartDateTime);
    on<SelectEndDateTimeEvent>(_selectEndDateTime);
    on<SelectRecurrenceEndDateTimeEvent>(_selectRecurrenceEndDateTime);
    on<ValidateDatesEvent>(_validateDates);
    on<OnSubmitRecurrentDateEvent>(_onSubmitForm);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  /// Initializes the recurrent date form.
  /// If [event.scheduleId] is provided, it fetches the existing schedule for editing.
  /// Otherwise, it sets up a new form for creating a recurrent date.
  void _initializeRecurrentDateForm(InitializeRecurrentDateFormEvent event, Emitter<RecurrentDateFormState> emit) async {
    try {
      if(event.scheduleId == null){
        // New recurrent date
        emit(state.copyWith(
          newRecurrentDateFormElements: RecurrenceFormElements(
            noteId: event.noteId,
            scheduleId: Uuid().v4(),
            selectedStartDateTime: .now(),
            selectedEndDateTime: .now().add(const Duration(hours: 1)),
          )
        ));
        return;
      } else{
        // Fetching schedule from repository
        ScheduleEntity? schedule = await scheduleRepository.getScheduleById(event.scheduleId!);
        if(schedule == null) {
          // Try to retrieve from [SaveNoteBloc] if not found in repository
          SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
          schedule = dataBloc.state.recurrentSchedules.firstWhereOrNull(
              (schedule) => schedule.id == event.scheduleId
          );
          if (schedule == null) {
            // Handle schedule not found
            debugPrint('Error initializing recurrent date form: Schedule not found');
            return;
          }
        }
        emit(state.copyWith(
          isEditing: true,
          newRecurrentDateFormElements: schedule.toRecurrenceFormElements()
        ));
      }
    } catch (e) {
      debugPrint('Error initializing recurrent date form: $e');
    }
  }

  /// Handles selection of recurrence type
  void _selectRecurrenceType(SelectRecurrenceTypeEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceType: event.recurrenceType
    );
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements,
    ));
  }

  /// Handles changes to the recurrence day interval
  void _changeRecurrenceDayInterval(ChangeRecurrenceDayIntervalEvent event, Emitter<RecurrentDateFormState> emit) {
    int? interval = int.tryParse(event.interval);

    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceDaysInterval: interval
    );
    // Validate interval (>0)
    final PositiveValueValidator intervalValidator = PositiveValueValidator.dirty(interval);
    Formz.validate([intervalValidator]);
    // Emit state update
    emit(state.copyWith(
        newRecurrentDateFormElements: currentElements,
        intervalDaysValidator: intervalValidator
    ));
  }

  /// Handles changes to the recurrence year interval
  void _changeRecurrenceYearInterval(ChangeRecurrenceYearIntervalEvent event, Emitter<RecurrentDateFormState> emit) {
    int? interval = int.tryParse(event.interval);

    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceYearsInterval: interval
    );
    // Validate interval (>0)
    final PositiveValueValidator intervalValidator = PositiveValueValidator.dirty(interval);
    Formz.validate([intervalValidator]);
    // Emit state update
    emit(state.copyWith(
        newRecurrentDateFormElements: currentElements,
        intervalYearsValidator: intervalValidator
    ));
  }

  /// Handles changes to the recurrence month date
  void _changeRecurrenceMonthDate(ChangeRecurrenceMonthDateEvent event, Emitter<RecurrentDateFormState> emit) {
    int? day = int.tryParse(event.day);

    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceMonthDate: day
    );
    // Validate day of month (1-31)
    final MonthDayValidator monthDayValidator = MonthDayValidator.dirty(day);
    Formz.validate([monthDayValidator]);
    // Emit state update
    emit(state.copyWith(
        newRecurrentDateFormElements: currentElements,
        monthDateValidator: monthDayValidator
    ));
  }

  /// Handles changes to the selected recurrence weekdays
  void _changeRecurrenceWeekDays(ChangeRecurrenceWeekDaysEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceWeekdays: event.weekDays
    );
    emit(state.copyWith(
        newRecurrentDateFormElements: currentElements
    ));
  }

  //region Date selection and validation
  /// Handles selection of start date and time
  void _selectStartDateTime(SelectStartDateTimeEvent event, Emitter<RecurrentDateFormState> emit) {
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
    // Validate dates
    add(ValidateDatesEvent());
  }

  /// Handles selection of end date and time
  void _selectEndDateTime(SelectEndDateTimeEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedEndDateTime: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    // Validate dates
    add(ValidateDatesEvent());
  }

  /// Handles selection of recurrence end date and time (optional)
  void _selectRecurrenceEndDateTime(SelectRecurrenceEndDateTimeEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceEndDate: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    // Validate dates
    add(ValidateDatesEvent());
  }

  /// Validates the start, end, and recurrence end dates
  void _validateDates(ValidateDatesEvent event, Emitter<RecurrentDateFormState> emit) {
    emit(state.copyWith(
        isValidEndDate: state.checkValidEndDate,
        isValidEndRecurrenceDate: state.checkRecurrenceEndDate
    ));
  }

  /// Handles form submission for recurrent date schedule
  /// Converts form elements to [ScheduleEntity] and dispatches event to [SaveNoteBloc]
  void _onSubmitForm(OnSubmitRecurrentDateEvent event, Emitter<RecurrentDateFormState> emit) {
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
    // Convert form elements to ScheduleEntity
    ScheduleEntity recurrentDateSchedule = ScheduleEntity.fromRecurrenceFormElements(
        state.newRecurrentDateFormElements
    );
    // Dispatch event to SaveNoteBloc to handle the recurrent date schedule
    dataBloc.add(SaveRecurrentDateEvent(recurrentDateSchedule));
  }
//endregion
}
