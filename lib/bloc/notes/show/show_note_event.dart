part of 'show_note_bloc.dart';

class ShowNoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetNoteById extends ShowNoteEvent {
  final String? noteId;

  GetNoteById(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

final class WatchSchedulesAndAlarmsByNoteId extends ShowNoteEvent {
  final String? noteId;

  WatchSchedulesAndAlarmsByNoteId(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

final class OnChangeNoteContent extends ShowNoteEvent {
  @override
  List<Object?> get props => [];
}

final class DeleteNoteById extends ShowNoteEvent {
  final String? noteId;

  DeleteNoteById(this.noteId);

  @override
  List<Object?> get props => [noteId];
}