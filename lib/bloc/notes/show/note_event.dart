part of 'note_bloc.dart';

class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class WatchNoteById extends NoteEvent {
  final String? noteId;

  WatchNoteById(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

final class DeleteNoteById extends NoteEvent {
  final int? noteId;

  DeleteNoteById(this.noteId);

  @override
  List<Object?> get props => [noteId];
}