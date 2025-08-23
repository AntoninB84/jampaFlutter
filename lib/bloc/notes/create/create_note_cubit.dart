import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/repository/categories_repository.dart';
import 'package:jampa_flutter/utils/forms/content_validator.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';

part 'create_note_state.dart';

class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit({
    required this.notesRepository,
  }) : super(const CreateNoteState());

  final NotesRepository notesRepository;

  void fetchNoteForUpdate(String? noteId) {
    if(noteId != null){
      try {
        int? id = int.tryParse(noteId);
        if(id != null){
          // Fetch the note by ID and update the state
          notesRepository.getNoteById(id)
            .then((note) {
              if (note != null) {
                emit(state.copyWith(
                  note: note,
                  title: NameValidator.dirty(note.title),
                  isValidTitle: Formz.validate([NameValidator.dirty(note.title)]),
                  content: ContentValidator.dirty(note.content),
                  isValidContent: Formz.validate([ContentValidator.dirty(note.content)]),
                ));
              } else {
                emit(state.copyWith(isError: true));
              }
            }).catchError((error) {
              emit(state.copyWith(isError: true));
              debugPrint('Error fetching note for update: $error');
            });
        }
      } catch (e) {
        emit(state.copyWith(isError: true));
        debugPrint('Error initializing fetchNoteForUpdate: $e');
      }
    }
  }

  void onNameChanged(String value) {
    final title = NameValidator.dirty(value);
    emit(
        state.copyWith(
          title: title,
          isValidTitle: Formz.validate([title]),
          isError: false, // Reset error state on name change
          isSuccess: false, // Reset success state on name change
        )
    );
  }

  void onContentChanged(String value) {
    final content = ContentValidator.dirty(value);
    emit(
        state.copyWith(
          content: content,
          isValidContent: Formz.validate([content]),
          isError: false, // Reset error state on content change
          isSuccess: false, // Reset success state on content change
        )
    );
  }

  void onSelectedCategoriesChanged(List<CategoryEntity> categories) {
    emit(
        state.copyWith(
          selectedCategories: categories,
        )
    );
  }

  void onSelectedNoteTypeChanged(NoteTypeEntity? noteType) {
    emit(
        state.copyWith(
          selectedNoteType: noteType,
        )
    );
  }

  Future<void> onSubmit() async {
    final title = NameValidator.dirty(state.title.value);
    final content = ContentValidator.dirty(state.content.value);
    emit(
      state.copyWith(
        title: title,
        content: content,
        isValidTitle: Formz.validate([title]),
        isValidContent: Formz.validate([content]),
      )
    );

    if (state.isValidTitle && state.isValidContent) {
      // If the name is valid, start loading
      emit(
          state.copyWith(
              isLoading: true,
              isError: false,
              isSuccess: false
          )
      );

      late NoteEntity note;
      if(state.note != null){
        note = state.note!.copyWith(
            title: state.title.value,
            content: state.content.value,
            noteTypeId: state.selectedNoteType?.id,
            categories: state.selectedCategories,
            createdAt: state.note!.createdAt,
            updatedAt: DateTime.now()
        );
      }else{
        note = NoteEntity(
            title: state.title.value,
            content: state.content.value,
            noteTypeId: state.selectedNoteType?.id,
            categories: state.selectedCategories,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()
        );
      }

      // If the note does not exist, save it
      notesRepository.saveNote(note)
      .then((_) {
        // If the note is saved successfully, emit a success state
        emit(state.copyWith(isSuccess: true, isLoading: false));
      })
      .catchError((error){
        // If an error occurs while saving, emit a state indicating an error
        emit(state.copyWith(isError: true, isLoading: false));
        debugPrint('Error saving note: $error');
      });
    }
  }
}