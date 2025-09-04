import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'save_single_date_state.dart';

class SaveSingleDateCubit extends Cubit<SaveSingleDateState> {
  SaveSingleDateCubit({
    bool? isSavingPersistentData,
    int? noteId
  }) : super(SaveSingleDateState(
    noteId: noteId,
    isSavingPersistentDate: isSavingPersistentData ?? false,
    selectedStartDateTime: DateTime.now(),
    selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
  ));

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void initializeWithData({
    SingleDateFormElements? singleDateFormElements, 
    int? initialElementIndex,
    bool isSavingPersistentDate = false
  }) {
    if(singleDateFormElements != null){
      emit(state.copyWith(
        isSavingPersistentDate: isSavingPersistentDate,
        initialSingleDateFormElements: singleDateFormElements,
        initialSingleDateFormElementIndex: initialElementIndex,
        selectedStartDateTime: singleDateFormElements.selectedStartDateTime,
        selectedEndDateTime: singleDateFormElements.selectedEndDateTime,
      ));
    }else{
      throw Exception("SingleDateFormElements must be provided when initializing with data.");
    }
  }

  void selectStartDateTime(DateTime dateTime) {
    emit(state.copyWith(selectedStartDateTime: dateTime));
    _validateDates();
  }

  void selectEndDateTime(DateTime dateTime) {
    emit(state.copyWith(selectedEndDateTime: dateTime));
    _validateDates();
  }

  void _validateDates() {
    final isValid = state.selectedStartDateTime != null &&
        state.selectedEndDateTime != null &&
        state.selectedStartDateTime!.isBefore(state.selectedEndDateTime!);
    emit(state.copyWith(isValidDate: isValid));
  }

  void onSubmit() async {
    if(state.isValidDate){
      late SingleDateFormElements newElement;

      if(state.isSavingPersistentDate ?? false){
        if(state.initialSingleDateFormElements != null){
          // Editing an existing persistent date
          newElement = state.initialSingleDateFormElements!.copyWith(
            selectedStartDateTime: state.selectedStartDateTime!,
            selectedEndDateTime: state.selectedEndDateTime!,
            //TODO alarms
          );
        }else{
          // Creating a new persistent date
          newElement = SingleDateFormElements(
            noteId: state.noteId,
            selectedStartDateTime: state.selectedStartDateTime!,
            selectedEndDateTime: state.selectedEndDateTime!,
            //TODO alarms
          );
        }

        await scheduleRepository.saveSingleDateFormElement(
            formElements: newElement,
            noteId: newElement.noteId!
        );

      }else{
        newElement = SingleDateFormElements(
          selectedStartDateTime: state.selectedStartDateTime!,
          selectedEndDateTime: state.selectedEndDateTime!,
          //TODO alarms
        );
      }
      
      emit(state.copyWith(
        createdSingleDateFormElements: newElement,
        hasSubmitted: true
      ));
    }
  }
}