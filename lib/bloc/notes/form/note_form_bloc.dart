import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/category.dart';
import '../../../data/models/note_type.dart';
import '../../../utils/helpers/utils.dart';
import '../save/save_note_bloc.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';

/// Bloc to manage the state of the note form, including initialization, field changes, and saving.
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  NoteFormBloc() : super(NoteFormState(
    noteId: const Uuid().v4(),
    quillController: QuillController.basic(),
  )) {
    on<InitializeNoteFormEvent>(_initializeNoteForm);
    on<TitleChangedEvent>(_onNameChanged,
        transformer: Utils.debounceTransformer(const Duration(milliseconds: 500))
    );
    on<SelectedCategoriesChangedEvent>(_onSelectedCategoriesChanged);
    on<SelectedNoteTypeChangedEvent>(_onSelectedNoteTypeChanged);
    on<ImportantCheckedChangedEvent>(_onImportantCheckedChanged);
    on<SaveNoteFormEvent>(_onSaveNoteForm);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();

  /// Initializes the note form with existing note data if a note ID is provided.
  void _initializeNoteForm(InitializeNoteFormEvent event, Emitter<NoteFormState> emit) async {
    try {
      // Fetch existing note data
      final note = await notesRepository.getNoteById(event.noteId);
      if (note == null) {
        // If note not found, emit failure state as
        // this method is not called if not in editing mode
        emit(state.copyWith(status: NoteFormStatus.failure));
        return;
      }

      // Populate the Quill controller with existing content
      state.quillController.document = note.content != null
          ? Document.fromJson(jsonDecode(note.content!))
          : Document();

      emit(state.copyWith(
        noteId: note.id,
        title: NameValidator.dirty(note.title),
        selectedNoteType: note.noteType,
        selectedCategories: note.categories,
        isImportantChecked: note.isImportant,
        status: NoteFormStatus.initial,
      ));
    } catch (e) {
      emit(state.copyWith(status: NoteFormStatus.failure));
      debugPrint('Error initializing note form: $e');
    }
  }

  /// Handles changes to the note title.
  void _onNameChanged(TitleChangedEvent event, Emitter<NoteFormState> emit) {
    final title = NameValidator.dirty(event.title);
    // Validating input
    Formz.validate([title]);
    emit(
        state.copyWith(
          title: title,
          // Reset error state on title change
          status: NoteFormStatus.initial
        )
    );
  }

  /// Handles changes to the selected categories.
  void _onSelectedCategoriesChanged(SelectedCategoriesChangedEvent event, Emitter<NoteFormState> emit) {
    emit(
        state.copyWith(
          selectedCategories: event.categories,
        )
    );
  }

  /// Handles changes to the selected note type.
  void _onSelectedNoteTypeChanged(SelectedNoteTypeChangedEvent event, Emitter<NoteFormState> emit) {
    emit(
        state.copyWith(
          selectedNoteType: event.noteType,
        )
    );
  }

  /// Handles changes to the important checkbox
  void _onImportantCheckedChanged(ImportantCheckedChangedEvent event, Emitter<NoteFormState> emit) {
    emit(
        state.copyWith(
          isImportantChecked: event.isChecked,
        )
    );
  }

  /// Handles saving the note form, either creating a new note or updating an existing one.
  /// The note data is passed to the [SaveNoteBloc] for persistence or in-memory storage.
  Future<void> _onSaveNoteForm(SaveNoteFormEvent event, Emitter<NoteFormState> emit) async {
    // TODO implement loading indicator in UI
    emit(state.copyWith(status: NoteFormStatus.loading));
    // Access SaveNoteBloc to handle saving
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
    // Get existing note if editing
    NoteEntity? note = dataBloc.state.note;

    // Convert Quill document to JSON string
    String? content = state.quillController.document.isEmpty()
        ? null : jsonEncode(state.quillController.document.toDelta().toJson());

    if(note != null) {
      // Update existing note
      note = note.copyWith(
        title: state.title.value,
        content: content,
        noteTypeId: state.selectedNoteType?.id,
        noteType: state.selectedNoteType,
        categories: state.selectedCategories,
        isImportant: state.isImportantChecked,
        updatedAt: DateTime.now(),
      );
    } else {
      // Create new note
      note = NoteEntity(
        id: state.noteId,
        title: state.title.value,
        content: content,
        noteTypeId: state.selectedNoteType?.id,
        noteType: state.selectedNoteType,
        categories: state.selectedCategories,
        isImportant: state.isImportantChecked,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    // Pass note to SaveNoteBloc for saving
    dataBloc.add(SetNoteEntityEvent(note));
    // Trigger save operation
    dataBloc.add(SaveNoteEventSubmit());
    emit(state.copyWith(status: NoteFormStatus.success, noteId: note.id));
  }
}
