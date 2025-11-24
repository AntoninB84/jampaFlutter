part of 'note_form_bloc.dart';

sealed class NoteFormEvent extends Equatable {
  const NoteFormEvent();
}

/// Event to initialize the note form, optionally in editing mode.
class InitializeNoteFormEvent extends NoteFormEvent {
  final String noteId;
  final bool isEditing;

  const InitializeNoteFormEvent({
    required this.noteId,
    this.isEditing = false,
  });

  @override
  List<Object?> get props => [noteId];
}

/// Event triggered when the note title changes.
class TitleChangedEvent extends NoteFormEvent {
  final String title;

  const TitleChangedEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

/// Event triggered when the selected note type changes.
class SelectedNoteTypeChangedEvent extends NoteFormEvent {
  final NoteTypeEntity? noteType;

  const SelectedNoteTypeChangedEvent({required this.noteType});

  @override
  List<Object?> get props => [noteType];
}

/// Event triggered when the selected categories change.
class SelectedCategoriesChangedEvent extends NoteFormEvent {
  final List<CategoryEntity> categories;

  const SelectedCategoriesChangedEvent({required this.categories});

  @override
  List<Object?> get props => [categories];
}

/// Event triggered when the important checkbox state changes.
class ImportantCheckedChangedEvent extends NoteFormEvent {
  final bool isChecked;

  const ImportantCheckedChangedEvent({required this.isChecked});

  @override
  List<Object?> get props => [isChecked];
}

/// Event to submit the form and save the note.
class SaveNoteFormEvent extends NoteFormEvent {
  const SaveNoteFormEvent();

  @override
  List<Object?> get props => [];
}