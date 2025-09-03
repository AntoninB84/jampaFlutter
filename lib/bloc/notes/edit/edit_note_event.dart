part of 'edit_note_bloc.dart';

class EditNoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class FetchNoteForUpdate extends EditNoteEvent {
  FetchNoteForUpdate({required this.noteId});

  final String? noteId;

  @override
  List<Object?> get props => [noteId];
}

final class OnNameChanged extends EditNoteEvent {
  OnNameChanged({required this.value});

  final String value;

  @override
  List<Object?> get props => [value];
}

final class OnContentChanged extends EditNoteEvent {
  OnContentChanged({required this.value});

  final String value;

  @override
  List<Object?> get props => [value];
}

final class OnSelectedNoteTypeChanged extends EditNoteEvent {
  OnSelectedNoteTypeChanged({required this.noteType});

  final NoteTypeEntity? noteType;

  @override
  List<Object?> get props => [noteType];
}

final class OnSelectedCategoriesChanged extends EditNoteEvent {
  OnSelectedCategoriesChanged({required this.categories});

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

final class OnIsImportantCheckedChanged extends EditNoteEvent {
  OnIsImportantCheckedChanged({required this.isChecked});

  final bool isChecked;

  @override
  List<Object?> get props => [isChecked];
}

final class OnSubmit extends EditNoteEvent {}

final class OnResetState extends EditNoteEvent {}