import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/data/models/category.dart';
import 'package:jampa_flutter/data/models/note.dart';
import 'package:jampa_flutter/data/models/note_type.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/extensions/datetime_extension.dart';
import 'package:jampa_flutter/utils/forms/name_validator.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../data/models/schedule.dart';
import '../../../utils/helpers/alarm_helpers.dart';

part 'create_note_state.dart';

/// Cubit to manage the state of creating or editing a note
/// All Schedule related data (SingleDate, Recurrence, Alarms) are managed in memory only
/// and will be saved to persistent storage when the note is saved.
class CreateNoteCubit extends Cubit<CreateNoteState> {
  CreateNoteCubit() : super(const CreateNoteState());

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

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

  void onContentChanged(Document? value) {
    emit(
        state.copyWith(
          content: value,
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

  void onImportantCheckedChanged(bool isChecked) {
    emit(
        state.copyWith(
          isImportantChecked: isChecked,
        )
    );
  }

  void onAddSingleDateElement(SingleDateFormElements element) {
    final updatedElements = List<SingleDateFormElements>.from(state.selectedSingleDateElements)
      ..add(element);
    emit(
        state.copyWith(
          selectedSingleDateElements: updatedElements,
        )
    );
  }

  void onUpdateSingleDateElement(int index, SingleDateFormElements element) {
    final updatedElements = List<SingleDateFormElements>.from(state.selectedSingleDateElements);
    if (index >= 0 && index < updatedElements.length) {
      updatedElements[index] = element;
      emit(
          state.copyWith(
            selectedSingleDateElements: updatedElements,
          )
      );
    }
  }

  void onRemoveSingleDateElement(int index) {
    final updatedElements = List<SingleDateFormElements>.from(state.selectedSingleDateElements);
    if (index >= 0 && index < updatedElements.length) {
      updatedElements.removeAt(index);
      emit(
          state.copyWith(
            selectedSingleDateElements: updatedElements,
          )
      );
    }
  }

  void onAddRecurrenceElement(RecurrenceFormElements element) {
    final updatedElements = List<RecurrenceFormElements>.from(state.selectedRecurrences)
      ..add(element);
    emit(
        state.copyWith(
          selectedRecurrences: updatedElements,
        )
    );
  }

  void onUpdateRecurrenceElement(int index, RecurrenceFormElements element) {
    final updatedElements = List<RecurrenceFormElements>.from(state.selectedRecurrences);
    if (index >= 0 && index < updatedElements.length) {
      updatedElements[index] = element;
      emit(
          state.copyWith(
            selectedRecurrences: updatedElements,
          )
      );
    }
  }

  void onRemoveRecurrenceElement(int index) {
    final updatedElements = List<RecurrenceFormElements>.from(state.selectedRecurrences);
    if (index >= 0 && index < updatedElements.length) {
      updatedElements.removeAt(index);
      emit(
          state.copyWith(
            selectedRecurrences: updatedElements,
          )
      );
    }
  }

  Future<void> onSubmit() async {
    final title = NameValidator.dirty(state.title.value);
    emit(
      state.copyWith(
        title: title,
        isValidTitle: Formz.validate([title]),
      )
    );
    final String? content = state.content != null
        ? jsonEncode(state.content?.toDelta().toJson())
        : null;

    if (state.isValidTitle) {
      // If the name is valid, start loading
      emit(
          state.copyWith(
              isLoading: true,
              isError: false,
              isSuccess: false
          )
      );

      late NoteEntity note = NoteEntity(
          title: state.title.value,
          content: content,
          noteTypeId: state.selectedNoteType?.id,
          categories: state.selectedCategories,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()
      );

      // Save the note to persistent storage
      await notesRepository.saveNote(note)
      .then((insertedNote) async  {
        // After the note is saved, save the associated schedule elements
        List<ScheduleEntity> scheduleEntities = await scheduleRepository.saveDateFormElements(
            singleFormElementsList: state.selectedSingleDateElements,
            recurrenceFormElementsList: state.selectedRecurrences,
            noteId: insertedNote.id!
        );

        // Check and set alarm notifications if needed
        List<AlarmToSetup> alarmsToSetup = await AlarmHelpers.calculateAlarmDateFromSchedule(scheduleEntities);
        if(alarmsToSetup.isNotEmpty){
          if(alarmsToSetup.first.alarmDateTime.isBetween(DateTime.now(), DateTime.now().add(Duration(hours: 12)))){
            await AlarmHelpers.setAlarmNotification(alarmsToSetup[0]);
          }
        }

        // If successful, emit a state indicating success
        emit(state.copyWith(isSuccess: true, isLoading: false));
      })
      .catchError((error){
        // If an error occurs while saving, emit a state indicating an error
        emit(state.copyWith(isError: true, isLoading: false));
        debugPrint('Error saving note: $error');
      });
    }
  }

  void resetState() {
    emit(const CreateNoteState());
  }
}