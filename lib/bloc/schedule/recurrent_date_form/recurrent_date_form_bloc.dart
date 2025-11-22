import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
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

class RecurrentDateFormBloc extends Bloc<RecurrentDateFormEvent, RecurrentDateFormState> {
  RecurrentDateFormBloc() : super(RecurrentDateFormState(
      newRecurrentDateFormElements: RecurrenceFormElements(
        noteId: 'noteId',
        scheduleId: Uuid().v4(),
        selectedStartDateTime: DateTime.now(),
        selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
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

  void _initializeRecurrentDateForm(InitializeRecurrentDateFormEvent event, Emitter<RecurrentDateFormState> emit) async {
    try {
      if(event.scheduleId == null){
        // New recurrent date
        emit(state.copyWith(
          newRecurrentDateFormElements: RecurrenceFormElements(
            noteId: event.noteId,
            scheduleId: Uuid().v4(),
            selectedStartDateTime: DateTime.now(),
            selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
          )
        ));
        return;
      } else{
        // Fetching schedule from repository
        final schedule = await scheduleRepository.getScheduleById(event.scheduleId!);
        if(schedule == null) {
          // Try to retrieve from [SaveNoteBloc] if not found in repository
          SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
          final schedule = dataBloc.state.recurrentSchedules.firstWhereOrNull(
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
          newRecurrentDateFormElements: schedule!.toRecurrenceFormElements()
        ));
      }
    } catch (e) {
      debugPrint('Error initializing recurrent date form: $e');
    }
  }

  void _selectRecurrenceType(SelectRecurrenceTypeEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceType: event.recurrenceType
    );
    emit(state.copyWith(
      newRecurrentDateFormElements: currentElements,
    ));
  }

  void _changeRecurrenceDayInterval(ChangeRecurrenceDayIntervalEvent event, Emitter<RecurrentDateFormState> emit) {
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

  void _changeRecurrenceYearInterval(ChangeRecurrenceYearIntervalEvent event, Emitter<RecurrentDateFormState> emit) {
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

  void _changeRecurrenceMonthDate(ChangeRecurrenceMonthDateEvent event, Emitter<RecurrentDateFormState> emit) {
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

  void _changeRecurrenceWeekDays(ChangeRecurrenceWeekDaysEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceWeekdays: event.weekDays
    );
    emit(state.copyWith(
        newRecurrentDateFormElements: currentElements
    ));
  }

  //region Date selection and validation
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
    add(ValidateDatesEvent());
  }

  void _selectEndDateTime(SelectEndDateTimeEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedEndDateTime: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDatesEvent());
  }

  void _selectRecurrenceEndDateTime(SelectRecurrenceEndDateTimeEvent event, Emitter<RecurrentDateFormState> emit) {
    RecurrenceFormElements currentElements = state.newRecurrentDateFormElements.copyWith(
        selectedRecurrenceEndDate: event.dateTime
    );
    emit(state.copyWith(newRecurrentDateFormElements: currentElements));
    add(ValidateDatesEvent());
  }

  void _validateDates(ValidateDatesEvent event, Emitter<RecurrentDateFormState> emit) {
    emit(state.copyWith(
        isValidEndDate: state.checkValidEndDate,
        isValidEndRecurrenceDate: state.checkRecurrenceEndDate
    ));
  }

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
