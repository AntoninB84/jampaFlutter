part of 'note_types_bloc.dart';

class NoteTypesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetNoteTypes extends NoteTypesEvent {}

final class ListenNoteTypes extends NoteTypesEvent {}

final class DeleteNoteType extends NoteTypesEvent {
  final int selectedNoteTypeId;

  DeleteNoteType(this.selectedNoteTypeId);

  @override
  List<Object?> get props => [selectedNoteTypeId];
}