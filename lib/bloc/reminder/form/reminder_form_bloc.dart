import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/bloc/notes/save/save_note_bloc.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:uuid/uuid.dart';

import '../../../repository/reminder_repository.dart';
import '../../../utils/enums/reminder_offset_type_enum.dart';
import '../../../utils/forms/positive_number_validator.dart';
import '../../../utils/service_locator.dart';
import '../../notes/form/note_form_helpers.dart';

part 'reminder_form_event.dart';
part 'reminder_form_state.dart';

/// Bloc to manage the state of the reminder form
class ReminderFormBloc extends Bloc<ReminderFormEvent, ReminderFormState> {
  ReminderFormBloc() : super(ReminderFormState(
      newReminderFormElements: ReminderFormElements(
        scheduleId: 'scheduleId',
        reminderId: 'reminderId',
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

  /// Initializes the reminder form state based on whether it's a new reminder or editing an existing one.
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
        ReminderEntity? reminder = await alarmRepository.getReminderById(event.reminderId!);
        if (reminder == null) {
          // Try to retrieve from [SaveNoteBloc] if not found in repository
          SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
          reminder = dataBloc.state.reminders.firstWhereOrNull(
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
            newReminderFormElements: reminder.toReminderFormElements(),
            offsetNumberValidator: PositiveValueValidator.dirty(reminder.offsetValue)
        ));
      }
    } catch (e) {
      // Handle error
      debugPrint("Error initializing reminder form: $e");
    }
  }

  /// Handles selection of offset number and updates the state accordingly.
  void _selectOffsetNumber(SelectOffsetNumberEvent event, Emitter<ReminderFormState> emit) {
    // Parse the offset number and validate
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

  /// Handles selection of offset type and updates the state accordingly.
  void _selectOffsetType(SelectOffsetTypeEvent event, Emitter<ReminderFormState> emit) {
    ReminderFormElements currentElements = state.newReminderFormElements.copyWith(
        selectedOffsetType: event.offsetType
    );
    emit(state.copyWith(newReminderFormElements: currentElements));
  }

  /// Toggles the notification setting and updates the state accordingly.
  void _toggleIsNotification(ToggleIsNotificationEvent event, Emitter<ReminderFormState> emit) {
    ReminderFormElements currentElements = state.newReminderFormElements.copyWith(
        isNotification: event.isNotification
    );
    emit(state.copyWith(newReminderFormElements: currentElements));
  }

  /// Handles submission of the reminder form by dispatching the save event to [SaveNoteBloc].
  void _onSubmitReminderForm(OnSubmitReminderFormEvent event, Emitter<ReminderFormState> emit) async {
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
    // Create ReminderEntity from form elements
    ReminderEntity reminderEntity = ReminderEntity.fromReminderFormElements(
        state.newReminderFormElements);
    // Dispatch event to SaveNoteBloc to handle the reminder
    dataBloc.add(SaveReminderEvent(reminderEntity));
  }
}
