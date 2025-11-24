import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/utils/service_locator.dart';
import 'package:uuid/uuid.dart';

part 'save_note_type_state.dart';

/// Cubit to manage the state of saving a note type
/// Handles fetching, validating, and saving note types
class SaveNoteTypeCubit extends Cubit<SaveNoteTypeState> {
  SaveNoteTypeCubit() : super(const SaveNoteTypeState());

  final NoteTypesRepository noteTypesRepository =
        serviceLocator<NoteTypesRepository>();

  /// Fetches a note type by ID for updating
  /// If the note type is found, updates the state with its details
  void fetchNoteTypeForUpdate(String? noteTypeId) {
    if(noteTypeId != null){
      try {
        // Fetch the noteType by ID and update the state
        noteTypesRepository.getNoteTypeById(noteTypeId)
          .then((noteType) {
            if (noteType != null) {
              emit(state.copyWith(
                noteType: noteType,
                name: NameValidator.dirty(noteType.name),
                isValidName: Formz.validate([NameValidator.dirty(noteType.name)]),
              ));
            } else {
              emit(state.copyWith(isError: true));
            }
          }).catchError((error) {
            emit(state.copyWith(isError: true));
            debugPrint('Error fetching noteType for update: $error');
          });
      } catch (e) {
        emit(state.copyWith(isError: true));
        debugPrint('Error initializing fetchNoteTypeForUpdate: $e');
      }
    }
  }

  /// Handles changes to the name input field
  void onNameChanged(String value) {
    final name = NameValidator.dirty(value);
    emit(
        state.copyWith(
          name: name,
          isValidName: Formz.validate([name]),
          existsAlready: false, // Reset existence check on name change
          isError: false, // Reset error state on name change
          isSuccess: false, // Reset success state on name change
        )
    );
  }

  /// Submits the form to save the note type
  void onSubmit() {
    // Validate the name field
    final name = NameValidator.dirty(state.name.value);
    emit(
      state.copyWith(
        name: name,
        isValidName: Formz.validate([name]),
      )
    );

    // Proceed only if the name is valid
    if (state.isValidName) {
      // If the name is valid, start loading
      emit(
          state.copyWith(
              isLoading: true,
              isError: false,
              isSuccess: false
          )
      );
      // Check if the noteType already exists
      noteTypesRepository.getNoteTypeByName(name.value).then((noteType) {
        if (noteType != null) {
          // If the noteType already exists, emit a state indicating it
          emit(state.copyWith(existsAlready: true, isLoading: false));
        } else {
          late NoteTypeEntity noteType;
          if(state.noteType != null){
            noteType = state.noteType!.copyWith(
              name: state.name.value,
              createdAt: state.noteType!.createdAt,
              updatedAt: DateTime.now()
            );
          }else{
            noteType = NoteTypeEntity(
                id: Uuid().v4(),
                name: state.name.value,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()
            );
          }

          // If the noteType does not exist, save it
          noteTypesRepository
              .saveNoteType(noteType)
              .then((_) {
                // If the noteType is saved successfully, emit a success state
                emit(state.copyWith(isSuccess: true, isLoading: false));
              })
              .catchError((error){
                // If an error occurs while saving, emit a state indicating an error
                emit(state.copyWith(isError: true, isLoading: false));
                debugPrint('Error saving noteType: $error');
              });

        }
      }).catchError((error){
        // If an error occurs, emit a state indicating an error
        emit(state.copyWith(isError: true, isLoading: false));
        debugPrint('Error checking noteType existence: $error');
      });
    }
  }
}