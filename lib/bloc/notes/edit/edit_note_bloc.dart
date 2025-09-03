import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/data/models/schedule.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/forms/content_validator.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'edit_note_state.dart';
part 'edit_note_event.dart';

/// Bloc to manage the state of creating or editing a note
/// All Schedule related data (SingleDate, Recurrence, Alarms) are managed in memory only
/// and will be saved to persistent storage when the note is saved.
class EditNoteBloc extends Bloc<EditNoteEvent, EditNoteState> {
  EditNoteBloc() : super(const EditNoteState()) {
    on<FetchNoteForUpdate>(_fetchNoteForUpdate);
    on<OnNameChanged>(_onNameChanged);
    on<OnContentChanged>(_onContentChanged);
    on<OnSelectedCategoriesChanged>(_onSelectedCategoriesChanged);
    on<OnSelectedNoteTypeChanged>(_onSelectedNoteTypeChanged);
    on<OnIsImportantCheckedChanged>(_onImportantCheckedChanged);
    on<OnSubmit>(_onSubmit);
    on<OnResetState>(_resetState);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void _fetchNoteForUpdate(FetchNoteForUpdate event, Emitter<EditNoteState> emit) async {
    if(event.noteId != null){
      try {
        int? id = int.tryParse(event.noteId!);
        if(id != null){
          // Fetch the note by ID and update the state
          await notesRepository.getNoteById(id)
            .then((note) async {
              if (note != null) {
                emit(state.copyWith(
                  note: note,
                  title: NameValidator.dirty(note.title),
                  isValidTitle: Formz.validate([NameValidator.dirty(note.title)]),
                  content: ContentValidator.dirty(note.content),
                  isValidContent: Formz.validate([ContentValidator.dirty(note.content)]),
                  selectedNoteType: note.noteType,
                  selectedCategories: note.categories,
                  isImportantChecked: note.isImportant,
                ));

                // Listen to schedules related to this note
                await emit.onEach(
                    scheduleRepository.watchAllSchedulesByNoteId(note.id!),
                    onData: (data) {
                      // Separate schedules into single date and recurrence
                      List<SingleDateFormElements> singleDates= [];
                      List<RecurrenceFormElements> recurrentDates = [];

                      for (var schedule in data) {
                        if (schedule.recurrenceType != null) {
                          recurrentDates.add(schedule.toRecurrenceFormElements());
                        } else {
                          singleDates.add(schedule.toSingleDateFormElements());
                        }
                      }

                      emit(state.copyWith(
                        singleDates: singleDates,
                        recurrentDates: recurrentDates,
                      ));
                    },
                    onError: (error, stackTrace) {
                      emit(state.copyWith(isError: true));
                      debugPrint('Error listening to schedules for note: $error');
                    }
                );
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

  void _onNameChanged(OnNameChanged event, Emitter<EditNoteState> emit) {
    final title = NameValidator.dirty(event.value);
    emit(
        state.copyWith(
          title: title,
          isValidTitle: Formz.validate([title]),
          isError: false, // Reset error state on name change
          isSuccess: false, // Reset success state on name change
        )
    );
  }

  void _onContentChanged(OnContentChanged event, Emitter<EditNoteState> emit) {
    final content = ContentValidator.dirty(event.value);
    emit(
        state.copyWith(
          content: content,
          isValidContent: Formz.validate([content]),
          isError: false, // Reset error state on content change
          isSuccess: false, // Reset success state on content change
        )
    );
  }

  void _onSelectedCategoriesChanged(OnSelectedCategoriesChanged event, Emitter<EditNoteState> emit) {
    emit(
        state.copyWith(
          selectedCategories: event.categories,
        )
    );
  }

  void _onSelectedNoteTypeChanged(OnSelectedNoteTypeChanged event, Emitter<EditNoteState> emit) {
    emit(
        state.copyWith(
          selectedNoteType: event.noteType,
        )
    );
  }

  void _onImportantCheckedChanged(OnIsImportantCheckedChanged event, Emitter<EditNoteState> emit) {
    emit(
        state.copyWith(
          isImportantChecked: event.isChecked,
        )
    );
  }

  Future<void> _onSubmit(OnSubmit event, Emitter<EditNoteState> emit) async {
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

      late NoteEntity note = state.note!.copyWith(
          title: state.title.value,
          content: state.content.value,
          noteTypeId: state.selectedNoteType?.id,
          categories: state.selectedCategories,
          createdAt: state.note!.createdAt,
          updatedAt: DateTime.now()
      );

      // Update the note
      await notesRepository.saveNote(note)
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

  void _resetState(OnResetState event, Emitter<EditNoteState> emit) {
    emit(const EditNoteState());
  }
}