part of 'note_types_bloc.dart';

class NoteTypesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to watch note types and populate state with updates.
final class WatchNoteTypes extends NoteTypesEvent {}

/// Event to watch note types along with their associated note counts.
final class WatchNoteTypesWithCount extends NoteTypesEvent {}

/// Event to delete a specific note type by its ID.
final class DeleteNoteType extends NoteTypesEvent {
  final String selectedNoteTypeId;

  DeleteNoteType(this.selectedNoteTypeId);

  @override
  List<Object?> get props => [selectedNoteTypeId];
}