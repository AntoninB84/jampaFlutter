import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/reminder/reminder_cubit.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/reminder.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/extensions/schedule_extension.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../repository/reminder_repository.dart';
import '../../../repository/schedule_repository.dart';

part 'save_note_event.dart';
part 'save_note_state.dart';

/// Bloc responsible for managing the saving process of notes along with their schedules and reminders
///
/// This bloc handles events related to fetching, updating, and saving notes, single date schedules,
/// recurrent schedules, and reminders. It maintains an in-memory state of these entities
/// until they are persisted to the database.
class SaveNoteBloc extends Bloc<SaveNoteEvent, SaveNoteState> {
  SaveNoteBloc() : super(SaveNoteState()) {
    // Note related events
    on<FetchNoteEvent>(_onFetchNote);
    on<SetNoteEntityEvent>(_onSetNoteEntity);
    on<SaveNoteEventSubmit>(_onSaveNoteEvent);
    // Single date schedule events
    on<RemoveOrDeleteSingleDateEvent>(_onRemoveSingleDate);
    on<SaveSingleDateEvent>(_onSaveSingleDate);
    // Recurrent schedule events
    on<RemoveOrDeleteRecurrentDateEvent>(_onRemoveRecurrentDate);
    on<SaveRecurrentDateEvent>(_onSaveRecurrentDate);
    // Reminder events
    on<RemoveOrDeleteReminderEvent>(_onRemoveReminder);
    on<SaveReminderEvent>(_onSaveReminder);
    // Clean state event
    on<CleanStateEvent>(_resetState);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();
  final ReminderRepository reminderRepository = serviceLocator<ReminderRepository>();

  //region note
  /// Fetches the note by ID and updates the state with the note and its schedules and reminders
  Future<void> _onFetchNote(FetchNoteEvent event, Emitter<SaveNoteState> emit) async {
    if(event.noteId != null && !state.hasFetchedData){
      NoteEntity? fetchedNote = await notesRepository.getNoteById(event.noteId!);
      emit(state.copyWith(note: fetchedNote));

      if(fetchedNote != null){
        // Fetch associated schedules
        List<ScheduleEntity> singleDateSchedules =
          await scheduleRepository.getAllSchedulesByNoteId(fetchedNote.id);
        // Separate recurrent schedules
        List<ScheduleEntity> recurrentDateSchedules =
          singleDateSchedules.where((schedule) => schedule.isRecurring).toList();
        // Remove recurrent schedules so that only single date schedules remain
        singleDateSchedules.removeWhere((schedule) => schedule.isRecurring);

        emit(state.copyWith(
          hasFetchedData: true,
          note: fetchedNote,
          singleDateSchedules: singleDateSchedules,
          recurrentSchedules: recurrentDateSchedules,
        ));

        // Fetch associated reminders for both single date and recurrent schedules
        List<ReminderEntity> reminderEntities = [];
        if(singleDateSchedules.isNotEmpty){
          for(final schedule in singleDateSchedules){
            List<ReminderEntity> reminders = await reminderRepository.getAllRemindersByScheduleId(schedule.id);
            reminderEntities.addAll(reminders);
          }
        }
        if(recurrentDateSchedules.isNotEmpty){
          for(final schedule in recurrentDateSchedules){
            List<ReminderEntity> reminders = await reminderRepository.getAllRemindersByScheduleId(schedule.id);
            reminderEntities.addAll(reminders);
          }
        }

        if(reminderEntities.isNotEmpty){
          emit(state.copyWith(reminders: reminderEntities));
        }
      }
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

    // Save the note entity itself
    await notesRepository.saveNote(state.note!);

    // Save all single date schedules
    emit(state.copyWith(singleDateSavingStatus: SavingStatus.saving));
    await _onSaveAllSingleDates();
    emit(state.copyWith(singleDateSavingStatus: SavingStatus.saved));

    // Save all recurrent date schedules
    emit(state.copyWith(recurrentSavingStatus: SavingStatus.saving));
    await _onSaveAllRecurrentDates();
    emit(state.copyWith(recurrentSavingStatus: SavingStatus.saved));

    // Clear the note from state after saving
    emit(state.copyWith(noteSavingStatus: SavingStatus.saved));
  }
  //endregion

  //region single date schedule
  ///Removes the single date schedule from the in-memory list and persistent storage if applicable
  Future<void> _onRemoveSingleDate(RemoveOrDeleteSingleDateEvent event, Emitter<SaveNoteState> emit) async {
    List<ScheduleEntity> updatedSchedules = state.singleDateSchedules
        .where((schedule) => schedule.id != event.id)
        .toList();
    emit(state.copyWith(singleDateSchedules: updatedSchedules));

    // Also remove from persistent storage if it has an ID
    if(event.id.isNotEmpty) {
      await scheduleRepository.deleteScheduleById(event.id);
    }
  }

  ///Calls [_saveSingleDateSchedule] to save the single date schedule
  Future<void> _onSaveSingleDate(SaveSingleDateEvent event, Emitter<SaveNoteState> emit) async {
    emit(state.copyWith(singleDateSavingStatus: SavingStatus.saving));
    List<ScheduleEntity>? result = await _saveSingleDateSchedule(event.singleDateSchedule);
    if(result != null){
      emit(state.copyWith(
          singleDateSchedules: result,
          singleDateSavingStatus: SavingStatus.added
      ));
    }else{
      emit(state.copyWith(singleDateSavingStatus: SavingStatus.saved));
    }
  }

  ///Checks if the parent note is registered in database
  ///
  /// If not, it only adds the single date schedule to the in-memory list.
  /// If yes, it saves the single date schedule to persistent storage.
  Future<List<ScheduleEntity>?> _saveSingleDateSchedule(ScheduleEntity schedule) async {
    //Check if parent note exists in database
    NoteEntity? parentNote = await notesRepository.getNoteById(schedule.noteId);
    if(parentNote != null) {
      // The parent note is persistent, so we can save the schedule directly
      ScheduleEntity result = await scheduleRepository.saveSchedule(schedule);
      // Check and set reminders in ReminderCubit
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([schedule]);
      // Save all reminders associated with this schedule
      await _onSaveAllRemindersOfSchedule(scheduleId: schedule.id);
      // Update in-memory list
      List<ScheduleEntity> updatedSchedules = List<ScheduleEntity>.from(state.singleDateSchedules)
        ..add(result);
      return updatedSchedules;
    } else {
      // The parent note is not yet persistent, so we only update the in-memory list
      // Check if the schedule already exists in the in-memory list
      bool exists = state.singleDateSchedules.any((s) => s.id == schedule.id);
      if (!exists) {
        // If it doesn't exist in the in-memory list, add it
        List<ScheduleEntity> updatedSchedules = List<ScheduleEntity>.from(state.singleDateSchedules)
          ..add(schedule);
        return updatedSchedules;
      } else {
        // If it exists in the in-memory list, update it
        List<ScheduleEntity> updatedSchedules = state.singleDateSchedules.map((s) {
          if (s.id == schedule.id) {
            return schedule;
          }
          return schedule;
        }).toList();
        return updatedSchedules;
      }
    }
  }

  ///Saves all single date schedules to persistent storage
  Future<void> _onSaveAllSingleDates() async {
    for(final schedule in state.singleDateSchedules){
      await _saveSingleDateSchedule(schedule);
    }
  }
  //endregion

  //region recurrent schedules
  ///Removes the recurrent date schedule from the in-memory list and persistent storage if applicable
  Future<void> _onRemoveRecurrentDate(RemoveOrDeleteRecurrentDateEvent event, Emitter<SaveNoteState> emit) async {
    List<ScheduleEntity> updatedSchedules = state.recurrentSchedules
        .where((schedule) => schedule.id != event.id)
        .toList();
    emit(state.copyWith(recurrentSchedules: updatedSchedules));

    // Also remove from persistent storage if it has an ID
    if(event.id.isNotEmpty) {
      await scheduleRepository.deleteScheduleById(event.id);
    }
  }

  /// Calls [_saveRecurrentDateSchedule] to save the recurrent date schedule
  Future<void> _onSaveRecurrentDate(SaveRecurrentDateEvent event, Emitter<SaveNoteState> emit) async {
    emit(state.copyWith(recurrentSavingStatus: SavingStatus.saving));
    List<ScheduleEntity>? result = await _saveRecurrentDateSchedule(event.recurrentDateSchedule);
    emit(state.copyWith(
        recurrentSchedules: result,
        recurrentSavingStatus: SavingStatus.added
    ));
  }

  ///Checks if the parent note is registered in database
  ///
  /// If not, it only adds the recurrent date schedule to the in-memory list.
  /// If yes, it saves the recurrent date schedule to persistent storage.
  Future<List<ScheduleEntity>?> _saveRecurrentDateSchedule(ScheduleEntity schedule) async {
    //Check if parent note exists in database
    NoteEntity? parentNote = await notesRepository.getNoteById(schedule.noteId);
    if(parentNote != null) {
      // The parent note is persistent, so we can save the schedule directly
      ScheduleEntity result = await scheduleRepository.saveSchedule(schedule);
      // Check and set reminders in ReminderCubit
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([schedule]);
      // Save all reminders associated with this schedule
      await _onSaveAllRemindersOfSchedule(scheduleId: schedule.id);
      // Update in-memory list
      List<ScheduleEntity> updatedSchedules = List<ScheduleEntity>.from(state.recurrentSchedules)
        ..add(result);
      return updatedSchedules;
    } else {
      // The parent note is not yet persistent, so we only update the in-memory list
      // Check if the schedule already exists in the in-memory list
      bool exists = state.recurrentSchedules.any((s) => s.id == schedule.id);
      if (!exists) {
        // If it doesn't exist in the in-memory list, add it
        List<ScheduleEntity> updatedSchedules = List<ScheduleEntity>.from(state.recurrentSchedules)
          ..add(schedule);
        return updatedSchedules;
      } else {
        // If it exists in the in-memory list, update it
        List<ScheduleEntity> updatedSchedules = state.recurrentSchedules.map((s) {
          if (s.id == schedule.id) {
            return schedule;
          }
          return s;
        }).toList();
        return updatedSchedules;
      }
    }
  }

  ///Saves all recurrent date schedules to persistent storage
  Future<void> _onSaveAllRecurrentDates() async {
    for(final schedule in state.recurrentSchedules){
      await _saveRecurrentDateSchedule(schedule);
    }
  }
  //endregion

  //region reminders
  ///Removes the reminder from the in-memory list and persistent storage if applicable
  Future<void> _onRemoveReminder(RemoveOrDeleteReminderEvent event, Emitter<SaveNoteState> emit) async {
    List<ReminderEntity> updatedReminders = state.reminders
        .where((reminder) => reminder.id != event.id)
        .toList();
    emit(state.copyWith(reminders: updatedReminders));

    // Also remove from persistent storage if it has an ID
    if(event.id.isNotEmpty) {
      await reminderRepository.deleteReminderById(event.id);
    }
  }

  /// Calls [_saveReminder] to save the reminder
  Future<void> _onSaveReminder(SaveReminderEvent event, Emitter<SaveNoteState> emit) async {
    emit(state.copyWith(remindersSavingStatus: SavingStatus.saving));
    List<ReminderEntity>? result = await _saveReminder(event.reminder);
    emit(state.copyWith(
        reminders: result,
        remindersSavingStatus: SavingStatus.saved
    ));
  }

  ///Checks if the parent schedule is registered in database
  ///
  /// If not, it only adds the reminder to the in-memory list.
  /// If yes, it saves the reminder to persistent storage.
  Future<List<ReminderEntity>?> _saveReminder(ReminderEntity reminder) async {
    //Check if parent schedule exists in database
    ScheduleEntity? parentSchedule = await scheduleRepository.getScheduleById(reminder.scheduleId);
    if(parentSchedule != null) {
      // The parent schedule is persistent, so we can save the reminder directly
      ReminderEntity result = await reminderRepository.saveReminder(reminder);
      // Check and set reminders in ReminderCubit
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([parentSchedule]);
      // Update in-memory list
      List<ReminderEntity> updatedReminders = List<ReminderEntity>.from(state.reminders)
        ..add(result);
      return updatedReminders;
    } else {
      // The parent schedule is not yet persistent, so we only update the in-memory list
      // Check if the reminder already exists in the in-memory list
      bool exists = state.reminders.any((r) => r.id == reminder.id);
      if (!exists) {
        // If it doesn't exist in the in-memory list, add it
        List<ReminderEntity> updatedReminders = List<ReminderEntity>.from(state.reminders)
          ..add(reminder);
        return updatedReminders;
      } else {
        // If it exists in the in-memory list, update it
        List<ReminderEntity> updatedReminders = state.reminders.map((r) {
          if (r.id == reminder.id) {
            return reminder;
          }
          return r;
        }).toList();
        return updatedReminders;
      }
    }
  }

  ///Saves all reminders associated with the given schedule to persistent storage
  Future<void> _onSaveAllRemindersOfSchedule({required String scheduleId}) async {
    List<ReminderEntity> remindersToSave = state.reminders
        .where((reminder) => reminder.scheduleId == scheduleId)
        .toList();
    for(final reminder in remindersToSave){
      await _saveReminder(reminder);
    }
  }

  //endregion

  /// Resets the entire bloc state to its initial values
  void _resetState(CleanStateEvent event, Emitter<SaveNoteState> emit) {
    emit(SaveNoteState());
  }
}

