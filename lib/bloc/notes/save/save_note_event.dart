part of 'save_note_bloc.dart';

sealed class SaveNoteEvent extends Equatable {
  const SaveNoteEvent();
}

class CleanStateEvent extends SaveNoteEvent {
  @override
  List<Object?> get props => [];
}

//region note
/// Fetch note data from the database
class FetchNoteEvent extends SaveNoteEvent {
  final String? noteId;

  const FetchNoteEvent({this.noteId});

  @override
  List<Object?> get props => [noteId];
}

/// Set the note entity to be saved
class SetNoteEntityEvent extends SaveNoteEvent {
  final NoteEntity note;

  const SetNoteEntityEvent(this.note);

  @override
  List<Object?> get props => [note];
}

/// Submit the note to be saved in the database
/// This event triggers the saving process,
/// also saving all associated data like schedules and reminders
class SaveNoteEventSubmit extends SaveNoteEvent {
  @override
  List<Object?> get props => [];
}
//endregion

//region single date schedule
/// Add a new single date schedule to the single date schedule list
class AddSingleDateEvent extends SaveNoteEvent {
  final ScheduleEntity singleDateSchedule;

  const AddSingleDateEvent(this.singleDateSchedule);

  @override
  List<Object?> get props => [singleDateSchedule];
}

/// Update an existing single date schedule in the single date schedule list
class UpdateSingleDateEvent extends SaveNoteEvent {
  final ScheduleEntity singleDateSchedule;

  const UpdateSingleDateEvent(this.singleDateSchedule);

  @override
  List<Object?> get props => [singleDateSchedule];
}

/// Remove a single date schedule from the single date schedule list
/// OR delete it if it's already saved in the database
class RemoveSingleDateEvent extends SaveNoteEvent {
  final String id;

  const RemoveSingleDateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Save a single date schedule to the database
class SaveSingleDateEvent extends SaveNoteEvent {
  final ScheduleEntity singleDateSchedule;

  const SaveSingleDateEvent(this.singleDateSchedule);

  @override
  List<Object?> get props => [];
}

/// Save the entire single date schedule list to the database
class SaveSingleDateListEvent extends SaveNoteEvent {
  @override
  List<Object?> get props => [];
}
//endregion

//region recurrent date schedule
/// Add a new recurrent date schedule to the recurrent date schedule list
class AddRecurrentDateEvent extends SaveNoteEvent {
  final ScheduleEntity recurrentDateSchedule;

  const AddRecurrentDateEvent(this.recurrentDateSchedule);

  @override
  List<Object?> get props => [recurrentDateSchedule];
}

/// Update an existing recurrent date schedule in the recurrent date schedule list
class UpdateRecurrentDateEvent extends SaveNoteEvent {
  final ScheduleEntity recurrentDateSchedule;

  const UpdateRecurrentDateEvent(this.recurrentDateSchedule);

  @override
  List<Object?> get props => [recurrentDateSchedule];
}

/// Remove a recurrent date schedule from the recurrent date schedule list
/// OR delete it if it's already saved in the database
class RemoveRecurrentDateEvent extends SaveNoteEvent {
  final String id;

  const RemoveRecurrentDateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Save a recurrent date schedule to the database
class SaveRecurrentDateEvent extends SaveNoteEvent {
  final ScheduleEntity recurrentDateSchedule;

  const SaveRecurrentDateEvent(this.recurrentDateSchedule);

  @override
  List<Object?> get props => [];
}

/// Save the entire recurrent date schedule list to the database
class SaveRecurrentDateListEvent extends SaveNoteEvent {
  @override
  List<Object?> get props => [];
}
//endregion

//region reminders
/// Add a new reminder to the reminder list
class AddReminderEvent extends SaveNoteEvent {
  final ReminderEntity reminder;

  const AddReminderEvent(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

/// Update an existing reminder in the reminder list
class UpdateReminderEvent extends SaveNoteEvent {
  final ReminderEntity reminder;

  const UpdateReminderEvent(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

/// Remove a reminder from the reminder list
/// OR delete it if it's already saved in the database
class RemoveReminderEvent extends SaveNoteEvent {
  final String id;

  const RemoveReminderEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Save a reminder to the database
class SaveReminderEvent extends SaveNoteEvent {
  final ReminderEntity reminder;

  const SaveReminderEvent(this.reminder);

  @override
  List<Object?> get props => [];
}

/// Save the entire reminder list to the database
class SaveReminderListEvent extends SaveNoteEvent {
  @override
  List<Object?> get props => [];
}
//endregion