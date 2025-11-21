part of 'note_form_bloc.dart';

sealed class NoteFormEvent extends Equatable {
  const NoteFormEvent();
}

class InitializeNoteFormEvent extends NoteFormEvent {
  final String noteId;
  final bool isSavingPersistentData;

  const InitializeNoteFormEvent({
    required this.noteId,
    this.isSavingPersistentData = false
  });

  @override
  List<Object?> get props => [noteId, isSavingPersistentData];
}

class TitleChangedEvent extends NoteFormEvent {
  final String title;

  const TitleChangedEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class SelectedNoteTypeChangedEvent extends NoteFormEvent {
  final NoteTypeEntity? noteType;

  const SelectedNoteTypeChangedEvent({required this.noteType});

  @override
  List<Object?> get props => [noteType];
}

class SelectedCategoriesChangedEvent extends NoteFormEvent {
  final List<CategoryEntity> categories;

  const SelectedCategoriesChangedEvent({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class ImportantCheckedChangedEvent extends NoteFormEvent {
  final bool isChecked;

  const ImportantCheckedChangedEvent({required this.isChecked});

  @override
  List<Object?> get props => [isChecked];
}

class SaveNoteFormEvent extends NoteFormEvent {
  const SaveNoteFormEvent();

  @override
  List<Object?> get props => [];
}