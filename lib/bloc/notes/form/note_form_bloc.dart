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

  void _initializeNoteForm(InitializeNoteFormEvent event, Emitter<NoteFormState> emit) async {
    try {
      final note = await notesRepository.getNoteById(event.noteId);
      if (note == null) {
        emit(state.copyWith(status: NoteFormStatus.failure));
        return;
      }

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

  void _onNameChanged(TitleChangedEvent event, Emitter<NoteFormState> emit) {
    final title = NameValidator.dirty(event.title);
    Formz.validate([title]);
    emit(
        state.copyWith(
          title: title,
          // Reset error state on title change
          status: NoteFormStatus.initial
        )
    );
  }

  void _onSelectedCategoriesChanged(SelectedCategoriesChangedEvent event, Emitter<NoteFormState> emit) {
    emit(
        state.copyWith(
          selectedCategories: event.categories,
        )
    );
  }

  void _onSelectedNoteTypeChanged(SelectedNoteTypeChangedEvent event, Emitter<NoteFormState> emit) {
    emit(
        state.copyWith(
          selectedNoteType: event.noteType,
        )
    );
  }

  void _onImportantCheckedChanged(ImportantCheckedChangedEvent event, Emitter<NoteFormState> emit) {
    emit(
        state.copyWith(
          isImportantChecked: event.isChecked,
        )
    );
  }

  Future<void> _onSaveNoteForm(SaveNoteFormEvent event, Emitter<NoteFormState> emit) async {
    emit(state.copyWith(status: NoteFormStatus.loading));
    SaveNoteBloc dataBloc = serviceLocator<SaveNoteBloc>();
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
    dataBloc.add(SetNoteEntityEvent(note));
    dataBloc.add(SaveNoteEventSubmit());
    emit(state.copyWith(status: NoteFormStatus.success, noteId: note.id));
  }
}
