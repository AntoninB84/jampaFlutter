import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:uuid/uuid.dart';

import '../../../repository/reminder_repository.dart';
import '../../../utils/enums/alarm_offset_type_enum.dart';
import '../../../utils/forms/positive_number_validator.dart';
import '../../../utils/service_locator.dart';
import '../../notes/form/note_form_helpers.dart';

part 'reminder_form_event.dart';
part 'reminder_form_state.dart';

class ReminderFormBloc extends Bloc<ReminderFormEvent, ReminderFormState> {
  ReminderFormBloc() : super(ReminderFormState(
      newReminderFormElements: ReminderFormElements(
        scheduleId: 'scheduleId',
        reminderId: Uuid().v4(),
        selectedOffsetNumber: 10,
        selectedOffsetType: ReminderOffsetType.minutes,
        isNotification: true
      )
  )) {
    on<InitializeReminderFormEvent>(_initializeReminderForm);
    on<SelectOffsetNumberEvent>(_selectOffsetNumber);
    on<SelectOffsetTypeEvent>(_selectOffsetType);
    on<ToggleIsNotificationEvent>(_toggleIsNotification);
    on<OnSubmitReminderFormEvent>(_onSubmitReminderForm);
  }

  final ReminderRepository alarmRepository = serviceLocator<ReminderRepository>();

  void _initializeReminderForm(InitializeReminderFormEvent event, Emitter<ReminderFormState> emit) async {
    try {
      if (event.reminderId == null) {
        // New reminder
        emit(state.copyWith(
            newReminderFormElements: ReminderFormElements(
                scheduleId: event.scheduleId,
                reminderId: Uuid().v4(),
                selectedOffsetNumber: 10,
                selectedOffsetType: ReminderOffsetType.minutes,
                isNotification: true
            ),
        ));
        return;
      } else {
        // Fetching reminder from repository
        final reminder = await alarmRepository.getReminderById(event.reminderId!);
        if (reminder == null) {
          // Try to retrieve from [SaveNoteBloc] if not found in repository
          SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
          final reminder = dataBloc.state.reminders.firstWhereOrNull(
                  (reminder) => reminder.id == event.reminderId
          );
          if (reminder == null) {
            // Handle error: reminder not found
            debugPrint("Reminder not found for ID: ${event.reminderId}");
            return;
          }
        }
        emit(state.copyWith(
            isEditing: true,
            newReminderFormElements: reminder!.toReminderFormElements(),
            offsetNumberValidator: PositiveValueValidator.dirty(reminder.offsetValue)
        ));
      }
    } catch (e) {
      // Handle error
      debugPrint("Error initializing reminder form: $e");
    }
  }

  void _selectOffsetNumber(SelectOffsetNumberEvent event, Emitter<ReminderFormState> emit) {
    final parsedNumber = int.tryParse(event.offsetNumber) ?? 0;
    final number = PositiveValueValidator.dirty(parsedNumber);
    Formz.validate([number]);

    ReminderFormElements currentElements = state.newReminderFormElements.copyWith(
        selectedOffsetNumber: number.value
    );
    emit(state.copyWith(
        newReminderFormElements: currentElements,
        offsetNumberValidator: number,
    ));
  }

  void _selectOffsetType(SelectOffsetTypeEvent event, Emitter<ReminderFormState> emit) {
    ReminderFormElements currentElements = state.newReminderFormElements.copyWith(
        selectedOffsetType: event.offsetType
    );
    emit(state.copyWith(newReminderFormElements: currentElements));
  }

  void _toggleIsNotification(ToggleIsNotificationEvent event, Emitter<ReminderFormState> emit) {
    ReminderFormElements currentElements = state.newReminderFormElements.copyWith(
        isNotification: event.isNotification
    );
    emit(state.copyWith(newReminderFormElements: currentElements));
  }

  void _onSubmitReminderForm(OnSubmitReminderFormEvent event, Emitter<ReminderFormState> emit) async {
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
    // Create ReminderEntity from form elements
    ReminderEntity reminderEntity = ReminderEntity.fromReminderFormElements(
        state.newReminderFormElements);
    // Dispatch event to SaveNoteBloc to handle the reminder
    dataBloc.add(SaveReminderEvent(reminderEntity));
  }
}
