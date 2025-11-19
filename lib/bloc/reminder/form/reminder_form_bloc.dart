import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<ValidateOffsetNumberEvent>(_validateOffsetNumber);
    on<OnSubmitReminderFormEvent>(_onSubmitReminderForm);
  }

  final ReminderRepository alarmRepository = serviceLocator<ReminderRepository>();

  void _initializeReminderForm(InitializeReminderFormEvent event, Emitter<ReminderFormState> emit) async {
    try {
      if (event.reminderId == null) {
        // New reminder
        emit(state.copyWith(
            isSavingPersistentData: event.isSavingPersistentData,
            newReminderFormElements: ReminderFormElements(
                scheduleId: event.scheduleId,
                reminderId: Uuid().v4(),
                selectedOffsetNumber: 10,
                selectedOffsetType: ReminderOffsetType.minutes,
                isNotification: true
            )
        ));
        return;
      } else {
        // Editing existing reminder
        final reminder = await alarmRepository.getReminderById(
            event.reminderId!);
        if (reminder == null) {
          emit(state.copyWith()); //TODO
          return;
        }
        emit(state.copyWith(
            isSavingPersistentData: event.isSavingPersistentData,
            newReminderFormElements: reminder.toReminderFormElements()
        ));
      }
    } catch (e) {
      // Handle error
      // debugPrint("Error initializing reminder form: $e");
    }
  }

  void _selectOffsetNumber(SelectOffsetNumberEvent event, Emitter<ReminderFormState> emit) {
    final parsedNumber = int.tryParse(event.offsetNumber) ?? 0;
    final number = PositiveValueValidator.dirty(parsedNumber);

    ReminderFormElements currentElements = state.newReminderFormElements.copyWith(
        selectedOffsetNumber: number.value
    );
    emit(state.copyWith(
        newReminderFormElements: currentElements,
        offsetNumberValidator: number,
        isValidOffsetNumber: Formz.validate([number])
    ));
    add(ValidateOffsetNumberEvent());
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

  void _validateOffsetNumber(ValidateOffsetNumberEvent event, Emitter<ReminderFormState> emit) {
    final isValid = state.newReminderFormElements.selectedOffsetNumber > 0;
    emit(state.copyWith(isValidOffsetNumber: isValid));
  }

  void _onSubmitReminderForm(OnSubmitReminderFormEvent event, Emitter<ReminderFormState> emit) async {
    // TODO: Implement loading state
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
    if(state.isSavingPersistentData){
      // Saving to persistent storage
      ReminderEntity reminderEntity = ReminderEntity.fromReminderFormElements(
      state.newReminderFormElements);
      dataBloc.add(SaveReminderEvent(reminderEntity));
    } else {
      List<ReminderEntity> reminders = dataBloc.state.reminders;
      ReminderEntity reminderEntity = ReminderEntity.fromReminderFormElements(
          state.newReminderFormElements);

      if(reminders.isNotEmpty &&
          reminders.any((r) => r.id == reminderEntity.id)){
        // This is the edit of a non persistent reminder ->
        // Update existing reminder in the SaveNoteBloc
        dataBloc.add(UpdateReminderEvent(reminderEntity));
      } else {
        // This is a new non persistent reminder ->
        // Add to SaveNoteBloc
        dataBloc.add(AddReminderEvent(reminderEntity));
      }
    }
    // TODO: Implement success state
  }
}
