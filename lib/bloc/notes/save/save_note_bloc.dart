import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/reminder/reminder_cubit.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../repository/reminder_repository.dart';
import '../../../repository/schedule_repository.dart';

part 'save_note_event.dart';
part 'save_note_state.dart';

class SaveNoteBloc extends Bloc<SaveNoteEvent, SaveNoteState> {
  SaveNoteBloc() : super(SaveNoteState()) {
    // Note related events
    on<FetchNoteEvent>(_onFetchNote);
    on<SetNoteEntityEvent>(_onSetNoteEntity);
    on<SaveNoteEventSubmit>(_onSaveNoteEvent);
    // Single date schedule events
    on<AddSingleDateEvent>(_onAddSingleDate);
    on<UpdateSingleDateEvent>(_onUpdateSingleDate);
    on<RemoveSingleDateEvent>(_onRemoveSingleDate);
    on<SaveSingleDateEvent>(_onSaveSingleDate);
    on<SaveSingleDateListEvent>(_onSaveAllSingleDates);
    // Recurrent schedule events
    on<AddRecurrentDateEvent>(_onAddRecurrentDate);
    on<UpdateRecurrentDateEvent>(_onUpdateRecurrentDate);
    on<RemoveRecurrentDateEvent>(_onRemoveRecurrentDate);
    on<SaveRecurrentDateEvent>(_onSaveRecurrentDate);
    on<SaveRecurrentDateListEvent>(_onSaveAllRecurrentDates);
    // Reminder events
    on<AddReminderEvent>(_onAddReminder);
    on<UpdateReminderEvent>(_onUpdateReminder);
    on<RemoveReminderEvent>(_onRemoveReminder);
    on<SaveReminderEvent>(_onSaveReminder);
    on<SaveReminderListEvent>(_onSaveAllReminders);
    // Clean state event
    on<CleanStateEvent>(_resetState);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();
  final ReminderRepository reminderRepository = serviceLocator<ReminderRepository>();

  //region note
  /// Fetches the note by ID and updates the state with the note and its schedules
  Future<void> _onFetchNote(FetchNoteEvent event, Emitter<SaveNoteState> emit) async {
    if(event.noteId != null){
      NoteEntity? fetchedNote = await notesRepository.getNoteById(event.noteId!);
      emit(state.copyWith(note: fetchedNote));

      // if(fetchedNote != null){
      //   List<ScheduleEntity> schedules = await scheduleRepository.getAllSchedulesByNoteId(fetchedNote.id);
      //   List<ScheduleEntity> singleDateSchedules = schedules.where((schedule) => schedule.isRecurring).toList();
      //   schedules.removeWhere((schedule) => schedule.isRecurring);
      //
      //   emit(state.copyWith(
      //     note: fetchedNote,
      //     singleDateSchedules: singleDateSchedules,
      //     recurrentSchedules: schedules,
      //   ));
      //
      //   List<ReminderEntity> reminderEntities = [];
      //   if(schedules.isNotEmpty){
      //     for(final schedule in schedules){
      //       List<ReminderEntity> reminders = await reminderRepository.getAllRemindersByScheduleId(schedule.id);
      //       reminderEntities.addAll(reminders);
      //     }
      //   }
      //   if(singleDateSchedules.isNotEmpty){
      //     for(final schedule in singleDateSchedules){
      //       List<ReminderEntity> reminders = await reminderRepository.getAllRemindersByScheduleId(schedule.id);
      //       reminderEntities.addAll(reminders);
      //     }
      //   }
      //
      //   if(reminderEntities.isNotEmpty){
      //     emit(state.copyWith(reminders: reminderEntities));
      //   }
      // }
    }
  }

  /// Replaces the current note in state with the provided one
  void _onSetNoteEntity(SetNoteEntityEvent event, Emitter<SaveNoteState> emit) {
    emit(state.copyWith(note: event.note));
  }

  /// Handles the persistent saving of the note and its related data
  void _onSaveNoteEvent(SaveNoteEventSubmit event, Emitter<SaveNoteState> emit) async {
    if(state.note == null) return;
    emit(state.copyWith(noteSavingStatus: SavingStatus.saving));

    await notesRepository.saveNote(state.note!);
    add(SaveSingleDateListEvent());
    add(SaveRecurrentDateListEvent());

    // Clear the note from state after saving
    emit(state.copyWith(noteSavingStatus: SavingStatus.success, note: null)); // TODO check if okay
  }
  //endregion

  //region single date schedule
  ///Simply adds the single date schedule to the in-memory list
  void _onAddSingleDate(AddSingleDateEvent event, Emitter<SaveNoteState> emit) {
    final updatedSchedules = List<ScheduleEntity>.from(state.singleDateSchedules)
      ..add(event.singleDateSchedule);
    emit(state.copyWith(singleDateSchedules: updatedSchedules));
  }

  ///Updates the single date schedule in the in-memory list
  void _onUpdateSingleDate(UpdateSingleDateEvent event, Emitter<SaveNoteState> emit) {
    final updatedSchedules = state.singleDateSchedules.map((schedule) {
      if (schedule.id == event.singleDateSchedule.id) {
        return event.singleDateSchedule;
      }
      return schedule;
    }).toList();
    emit(state.copyWith(singleDateSchedules: updatedSchedules));
  }

  ///Removes the single date schedule from the in-memory list and persistent storage if applicable
  Future<void> _onRemoveSingleDate(RemoveSingleDateEvent event, Emitter<SaveNoteState> emit) async {
    final updatedSchedules = state.singleDateSchedules
        .where((schedule) => schedule.id != event.id)
        .toList();
    emit(state.copyWith(singleDateSchedules: updatedSchedules));

    // Also remove from persistent storage if it has an ID
    if(event.id.isNotEmpty) {
      await scheduleRepository.deleteScheduleById(event.id);
    }
  }

  ///Saves the single date schedule to persistent storage
  Future<void> _onSaveSingleDate(SaveSingleDateEvent event, Emitter<SaveNoteState> emit) async {
    // Save to persistent storage
    await scheduleRepository.saveSchedule(event.singleDateSchedule);
    await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([event.singleDateSchedule]);
  }

  ///Saves all single date schedules to persistent storage
  Future<void> _onSaveAllSingleDates(SaveSingleDateListEvent event, Emitter<SaveNoteState> emit) async {
    for(final schedule in state.singleDateSchedules){
      add(SaveSingleDateEvent(schedule));
    }
    emit(state.copyWith(singleDateSavingStatus: SavingStatus.success));
    // After saving all single date schedules, clear the in-memory list
    emit(state.copyWith(singleDateSchedules: List.of([])));
    // Also save all reminders after saving schedules
    add(SaveReminderListEvent());
  }
  //endregion

  //region recurrent schedules
  ///Simply adds the recurrent date schedule to the in-memory list
  void _onAddRecurrentDate(AddRecurrentDateEvent event, Emitter<SaveNoteState> emit) {
    final updatedSchedules = List<ScheduleEntity>.from(state.recurrentSchedules)
      ..add(event.recurrentDateSchedule);
    emit(state.copyWith(recurrentSchedules: updatedSchedules));
  }

  ///Updates the recurrent date schedule in the in-memory list
  void _onUpdateRecurrentDate(UpdateRecurrentDateEvent event, Emitter<SaveNoteState> emit) {
    final updatedSchedules = state.recurrentSchedules.map((schedule) {
      if (schedule.id == event.recurrentDateSchedule.id) {
        return event.recurrentDateSchedule;
      }
      return schedule;
    }).toList();
    emit(state.copyWith(recurrentSchedules: updatedSchedules));
  }

  ///Removes the recurrent date schedule from the in-memory list and persistent storage if applicable
  Future<void> _onRemoveRecurrentDate(RemoveRecurrentDateEvent event, Emitter<SaveNoteState> emit) async {
    final updatedSchedules = state.recurrentSchedules
        .where((schedule) => schedule.id != event.id)
        .toList();
    emit(state.copyWith(recurrentSchedules: updatedSchedules));

    // Also remove from persistent storage if it has an ID
    if(event.id.isNotEmpty) {
      await scheduleRepository.deleteScheduleById(event.id);
    }
  }

  ///Saves the recurrent date schedule to persistent storage
  Future<void> _onSaveRecurrentDate(SaveRecurrentDateEvent event, Emitter<SaveNoteState> emit) async {
    // Save to persistent storage
    await scheduleRepository.saveSchedule(event.recurrentDateSchedule);
    await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([event.recurrentDateSchedule]);
  }

  ///Saves all recurrent date schedules to persistent storage
  Future<void> _onSaveAllRecurrentDates(SaveRecurrentDateListEvent event, Emitter<SaveNoteState> emit) async {
    for(final schedule in state.recurrentSchedules){
      add(SaveRecurrentDateEvent(schedule));
    }
    emit(state.copyWith(recurrentSavingStatus: SavingStatus.success));
    // After saving all recurrent schedules, clear the in-memory list
    emit(state.copyWith(recurrentSchedules: List.of([])));
    // Also save all reminders after saving schedules
    add(SaveReminderListEvent());
  }
  //endregion

  //region reminders
  ///Simply adds the reminder to the in-memory list
  void _onAddReminder(AddReminderEvent event, Emitter<SaveNoteState> emit) {
    final updatedReminders = List<ReminderEntity>.from(state.reminders)
      ..add(event.reminder);
    emit(state.copyWith(reminders: updatedReminders));
  }

  ///Updates the reminder in the in-memory list
  void _onUpdateReminder(UpdateReminderEvent event, Emitter<SaveNoteState> emit) {
    final updatedReminders = state.reminders.map((reminder) {
      if (reminder.id == event.reminder.id) {
        return event.reminder;
      }
      return reminder;
    }).toList();
    emit(state.copyWith(reminders: updatedReminders));
  }

  ///Removes the reminder from the in-memory list and persistent storage if applicable
  Future<void> _onRemoveReminder(RemoveReminderEvent event, Emitter<SaveNoteState> emit) async {
    final updatedReminders = state.reminders
        .where((reminder) => reminder.id != event.id)
        .toList();
    emit(state.copyWith(reminders: updatedReminders));

    // Also remove from persistent storage if it has an ID
    if(event.id.isNotEmpty) {
      await reminderRepository.deleteReminderById(event.id);
    }
  }

  ///Saves the reminder to persistent storage
  Future<void> _onSaveReminder(SaveReminderEvent event, Emitter<SaveNoteState> emit) async {
    // Save to persistent storage
    await reminderRepository.saveReminder(event.reminder);
    ScheduleEntity? parentSchedule = await scheduleRepository.getScheduleById(event.reminder.scheduleId);
    if(parentSchedule != null){
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([parentSchedule]);
    }
  }

  ///Saves all reminders to persistent storage
  Future<void> _onSaveAllReminders(SaveReminderListEvent event, Emitter<SaveNoteState> emit) async {
    for(final reminder in state.reminders){
      add(SaveReminderEvent(reminder));
    }
    emit(state.copyWith(remindersSavingStatus: SavingStatus.success));
    // After saving all reminders, clear the in-memory list
    emit(state.copyWith(reminders: List.of([])));
  }
  //endregion

  /// Resets the entire bloc state to its initial values
  void _resetState(CleanStateEvent event, Emitter<SaveNoteState> emit) {
    emit(SaveNoteState());
  }
}

