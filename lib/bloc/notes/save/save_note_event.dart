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
/// Remove a single date schedule from the single date schedule in-memory list
/// OR delete it forever if it's already saved in the database
class RemoveOrDeleteSingleDateEvent extends SaveNoteEvent {
  final String id;

  const RemoveOrDeleteSingleDateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Save a single date schedule to the database if the parent note is already saved
/// Otherwise, it will be added to in-memory list and saved when the parent note is saved
class SaveSingleDateEvent extends SaveNoteEvent {
  final ScheduleEntity singleDateSchedule;

  const SaveSingleDateEvent(this.singleDateSchedule);

  @override
  List<Object?> get props => [];
}
//endregion

//region recurrent date schedule
/// Remove a recurrent date schedule from the recurrent date schedule list
/// OR delete it forever if it's already saved in the database
class RemoveOrDeleteRecurrentDateEvent extends SaveNoteEvent {
  final String id;

  const RemoveOrDeleteRecurrentDateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Save a recurrent date schedule to the database if the parent note is already saved
/// Otherwise, it will be added to in-memory list and saved when the parent note is saved
class SaveRecurrentDateEvent extends SaveNoteEvent {
  final ScheduleEntity recurrentDateSchedule;

  const SaveRecurrentDateEvent(this.recurrentDateSchedule);

  @override
  List<Object?> get props => [];
}
//endregion

//region reminders
/// Remove a reminder from the reminder in-memory list
/// OR delete it forever if it's already saved in the database
class RemoveOrDeleteReminderEvent extends SaveNoteEvent {
  final String id;

  const RemoveOrDeleteReminderEvent(this.id);

  @override
  List<Object?> get props => [id];
}

/// Save a reminder to the database if the parent schedule is already saved
/// Otherwise, it will be added to in-memory list and saved when the parent schedule is saved
class SaveReminderEvent extends SaveNoteEvent {
  final ReminderEntity reminder;

  const SaveReminderEvent(this.reminder);

  @override
  List<Object?> get props => [];
}
//endregion