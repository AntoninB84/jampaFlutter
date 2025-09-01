import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';

part 'create_single_date_state.dart';

class CreateSingleDateCubit extends Cubit<CreateSingleDateState> {
  CreateSingleDateCubit() : super(CreateSingleDateState(
    selectedStartDateTime: DateTime.now(),
    selectedEndDateTime: DateTime.now().add(const Duration(hours: 1)),
  ));

  void initializeWithData({
    SingleDateFormElements? singleDateFormElements, 
    int? initialElementIndex
  }) {
    if(singleDateFormElements != null){
      emit(state.copyWith(
        initialSingleDateFormElements: singleDateFormElements,
        initialSingleDateFormElementIndex: initialElementIndex,
        selectedStartDateTime: singleDateFormElements.selectedStartDateTime,
        selectedEndDateTime: singleDateFormElements.selectedEndDateTime,
      ));
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

  void onSubmit() {
    if(state.isValidDate){
      emit(state.copyWith(
        createdSingleDateFormElements: SingleDateFormElements(
          selectedStartDateTime: state.selectedStartDateTime,
          selectedEndDateTime: state.selectedEndDateTime,
          //TODO alarms
        ),
        hasSubmitted: true
      ));
    }
  }
}