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
    if(event.noteId != null){
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

    await notesRepository.saveNote(state.note!);
    await _onSaveAllSingleDates();
    await _onSaveAllRecurrentDates();

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

  ///Checks if the parent note is registered in database
  ///
  /// If not, it only adds the single date schedule to the in-memory list.
  /// If yes, it saves the single date schedule to persistent storage.
  Future<void> _onSaveSingleDate(SaveSingleDateEvent event, Emitter<SaveNoteState> emit) async {
    emit(state.copyWith(singleDateSavingStatus: SavingStatus.saving));
    //Check if parent note exists in database
    NoteEntity? parentNote = await notesRepository.getNoteById(event.singleDateSchedule.noteId);
    if(parentNote != null) {
      // The parent note is persistent, so we can save the schedule directly
      await scheduleRepository.saveSchedule(event.singleDateSchedule);
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([event.singleDateSchedule]);
      await _onSaveAllRemindersOfSchedule(scheduleId: event.singleDateSchedule.id);
      emit(state.copyWith(singleDateSavingStatus: SavingStatus.saved));
      return;
    } else {
      // The parent note is not yet persistent, so we only update the in-memory list
      // Check if the schedule already exists in the in-memory list
      bool exists = state.singleDateSchedules.any((schedule) => schedule.id == event.singleDateSchedule.id);
      if (!exists) {
        // If it doesn't exist in the in-memory list, add it
        List<ScheduleEntity> updatedSchedules = List<ScheduleEntity>.from(state.singleDateSchedules)
          ..add(event.singleDateSchedule);
        emit(state.copyWith(
          singleDateSchedules: updatedSchedules,
          singleDateSavingStatus: SavingStatus.added
        ));
        return;
      } else {
        // If it exists in the in-memory list, update it
        List<ScheduleEntity> updatedSchedules = state.singleDateSchedules.map((schedule) {
          if (schedule.id == event.singleDateSchedule.id) {
            return event.singleDateSchedule;
          }
          return schedule;
        }).toList();
        emit(state.copyWith(
            singleDateSchedules: updatedSchedules,
            singleDateSavingStatus: SavingStatus.saved
        ));
      }
    }
  }

  ///Saves all single date schedules to persistent storage
  Future<void> _onSaveAllSingleDates() async {
    for(final schedule in state.singleDateSchedules){
      add(SaveSingleDateEvent(schedule));
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

  ///Checks if the parent note is registered in database
  ///
  /// If not, it only adds the recurrent date schedule to the in-memory list.
  /// If yes, it saves the recurrent date schedule to persistent storage.
  Future<void> _onSaveRecurrentDate(SaveRecurrentDateEvent event, Emitter<SaveNoteState> emit) async {
    emit(state.copyWith(recurrentSavingStatus: SavingStatus.saving));
    //Check if parent note exists in database
    NoteEntity? parentNote = await notesRepository.getNoteById(event.recurrentDateSchedule.noteId);
    if(parentNote != null) {
      // The parent note is persistent, so we can save the schedule directly
      await scheduleRepository.saveSchedule(event.recurrentDateSchedule);
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([event.recurrentDateSchedule]);
      await _onSaveAllRemindersOfSchedule(scheduleId: event.recurrentDateSchedule.id);
      emit(state.copyWith(recurrentSavingStatus: SavingStatus.saved));
      return;
    } else {
      // The parent note is not yet persistent, so we only update the in-memory list
      // Check if the schedule already exists in the in-memory list
      bool exists = state.recurrentSchedules.any((schedule) => schedule.id == event.recurrentDateSchedule.id);
      if (!exists) {
        // If it doesn't exist in the in-memory list, add it
        List<ScheduleEntity> updatedSchedules = List<ScheduleEntity>.from(state.recurrentSchedules)
          ..add(event.recurrentDateSchedule);
        emit(state.copyWith(
            recurrentSchedules: updatedSchedules,
            recurrentSavingStatus: SavingStatus.added
        ));
        return;
      } else {
        // If it exists in the in-memory list, update it
        List<ScheduleEntity> updatedSchedules = state.recurrentSchedules.map((schedule) {
          if (schedule.id == event.recurrentDateSchedule.id) {
            return event.recurrentDateSchedule;
          }
          return schedule;
        }).toList();
        emit(state.copyWith(
            recurrentSchedules: updatedSchedules,
            recurrentSavingStatus: SavingStatus.saved
        ));
      }
    }
  }

  ///Saves all recurrent date schedules to persistent storage
  Future<void> _onSaveAllRecurrentDates() async {
    for(final schedule in state.recurrentSchedules){
      add(SaveRecurrentDateEvent(schedule));
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

  ///Checks if the parent schedule is registered in database
  ///
  /// If not, it only adds the reminder to the in-memory list.
  /// If yes, it saves the reminder to persistent storage.
  Future<void> _onSaveReminder(SaveReminderEvent event, Emitter<SaveNoteState> emit) async {
    emit(state.copyWith(remindersSavingStatus: SavingStatus.saving));
    //Check if parent schedule exists in database
    ScheduleEntity? parentSchedule = await scheduleRepository.getScheduleById(event.reminder.scheduleId);
    if(parentSchedule != null) {
      // The parent schedule is persistent, so we can save the reminder directly
      await reminderRepository.saveReminder(event.reminder);
      await serviceLocator<ReminderCubit>().checkAndSetFromSchedules([parentSchedule]);
      emit(state.copyWith(recurrentSavingStatus: SavingStatus.saved));
      return;
    } else {
      // The parent schedule is not yet persistent, so we only update the in-memory list
      // Check if the reminder already exists in the in-memory list
      bool exists = state.reminders.any((reminder) => reminder.id == event.reminder.id);
      if (!exists) {
        // If it doesn't exist in the in-memory list, add it
        List<ReminderEntity> updatedReminders = List<ReminderEntity>.from(state.reminders)
          ..add(event.reminder);
        emit(state.copyWith(
            reminders: updatedReminders,
            remindersSavingStatus: SavingStatus.added
        ));
        return;
      } else {
        // If it exists in the in-memory list, update it
        List<ReminderEntity> updatedReminders = state.reminders.map((reminder) {
          if (reminder.id == event.reminder.id) {
            return event.reminder;
          }
          return reminder;
        }).toList();
        emit(state.copyWith(
            reminders: updatedReminders,
            remindersSavingStatus: SavingStatus.saved
        ));
      }
    }
  }

  ///Saves all reminders associated with the given schedule to persistent storage
  Future<void> _onSaveAllRemindersOfSchedule({required String scheduleId}) async {
    List<ReminderEntity> remindersToSave = state.reminders
        .where((reminder) => reminder.scheduleId == scheduleId)
        .toList();
    for(final reminder in remindersToSave){
      add(SaveReminderEvent(reminder));
    }
  }

  //endregion

  /// Resets the entire bloc state to its initial values
  void _resetState(CleanStateEvent event, Emitter<SaveNoteState> emit) {
    emit(SaveNoteState());
  }
}

