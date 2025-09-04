import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'save_single_date_state.dart';

class SaveSingleDateCubit extends Cubit<SaveSingleDateState> {
  SaveSingleDateCubit() : super(SaveSingleDateState(
    newSingleDateFormElements: SingleDateFormElements(
      selectedStartDateTime: DateTime.now(),
      selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
    ),
  ));

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void initializeWithData({
    SingleDateFormElements? singleDateFormElements, 
    int? initialElementIndex,
    bool isSavingPersistentDate = false,
    int? noteId
  }) {
    if(singleDateFormElements != null){
      emit(state.copyWith(
        isSavingPersistentDate: isSavingPersistentDate,
        newSingleDateFormElements: singleDateFormElements,
        initialSingleDateFormElementIndex: initialElementIndex,
        noteId: noteId ?? singleDateFormElements.noteId,
      ));
    }else{
      throw Exception("SingleDateFormElements must be provided when initializing with data.");
    }
  }

  void selectStartDateTime(DateTime dateTime) {
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      selectedStartDateTime: dateTime
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
    _validateDates();
  }

  void selectEndDateTime(DateTime dateTime) {
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      selectedEndDateTime: dateTime
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
    _validateDates();
  }

  void _validateDates() {
    final isValid = state.newSingleDateFormElements.selectedStartDateTime != null &&
        state.newSingleDateFormElements.selectedEndDateTime != null &&
        state.newSingleDateFormElements.selectedStartDateTime!.isBefore(
            state.newSingleDateFormElements.selectedEndDateTime!
        );
    emit(state.copyWith(isValidDate: isValid));
  }

  //region In-memory alarm management
  void onAddAlarm(AlarmFormElements alarm) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newSingleDateFormElements.alarmsForSingleDate)
      ..add(alarm);
    SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
      alarmsForSingleDate: updatedAlarms
    );
    emit(state.copyWith(newSingleDateFormElements: currentElements));
  }

  void onUpdateAlarm(int index, AlarmFormElements updatedAlarm) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newSingleDateFormElements.alarmsForSingleDate);
    if(index >= 0 && index < updatedAlarms.length){
      updatedAlarms[index] = updatedAlarm;
      SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
        alarmsForSingleDate: updatedAlarms
      );
      emit(state.copyWith(newSingleDateFormElements: currentElements));
    }
  }

  void onRemoveAlarm(int index) {
    List<AlarmFormElements> updatedAlarms = List.from(state.newSingleDateFormElements.alarmsForSingleDate);
    if(index >= 0 && index < updatedAlarms.length){
      updatedAlarms.removeAt(index);
      SingleDateFormElements currentElements = state.newSingleDateFormElements.copyWith(
        alarmsForSingleDate: updatedAlarms
      );
      emit(state.copyWith(newSingleDateFormElements: currentElements));
    }
  }
  //endregion

  void onSubmit() async {
    if(state.isValidDate){
      SingleDateFormElements newElement = state.newSingleDateFormElements;

      if(state.isSavingPersistentDate ?? false){
        if(state.initialSingleDateFormElementIndex == null){
          // Creating a new persistent date
          newElement = state.newSingleDateFormElements.copyWith(
            noteId: state.noteId,
            createdAt: DateTime.now()
          );
        }

        await scheduleRepository.saveSingleDateFormElement(
            formElements: newElement,
            noteId: newElement.noteId!
        );
      }
      
      emit(state.copyWith(
        newSingleDateFormElements: newElement,
        hasSubmitted: true
      ));
    }
  }
}