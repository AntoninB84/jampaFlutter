part of 'note_types_bloc.dart';

class NoteTypesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


final class WatchNoteTypes extends NoteTypesEvent {}
final class WatchNoteTypesWithCount extends NoteTypesEvent {}

final class DeleteNoteType extends NoteTypesEvent {
  final String selectedNoteTypeId;

  DeleteNoteType(this.selectedNoteTypeId);

  @override
  List<Object?> get props => [selectedNoteTypeId];
}