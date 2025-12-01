part of 'show_note_bloc.dart';

class ShowNoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to get a note by its ID
final class GetNoteById extends ShowNoteEvent {
  final String? noteId;

  GetNoteById(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

/// Event to watch schedules and alarms associated with a note ID
final class WatchSchedulesAndAlarmsByNoteId extends ShowNoteEvent {
  final String? noteId;

  WatchSchedulesAndAlarmsByNoteId(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

/// Event to handle changes in note content
final class OnChangeNoteContent extends ShowNoteEvent {
  @override
  List<Object?> get props => [];
}

// Event to change status of the note
final class ChangeNoteStatus extends ShowNoteEvent {
  final String? noteId;
  final NoteStatusEnum newStatus;

  ChangeNoteStatus({this.noteId, required this.newStatus});

  @override
  List<Object?> get props => [noteId, newStatus];
}

/// Event to delete a note by its ID
final class DeleteNoteById extends ShowNoteEvent {
  final String? noteId;

  DeleteNoteById(this.noteId);

  @override
  List<Object?> get props => [noteId];
}