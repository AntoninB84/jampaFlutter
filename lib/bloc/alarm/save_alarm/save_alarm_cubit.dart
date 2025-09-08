import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../utils/enums/alarm_offset_type_enum.dart';
import '../../notes/create/create_note_form_helpers.dart';

part 'save_alarm_state.dart';

class SaveAlarmCubit extends Cubit<SaveAlarmState> {
  SaveAlarmCubit({
    bool? isSavingPersistentAlarm,
    int? scheduleId,
  }) : super(SaveAlarmState(
    scheduleId: scheduleId,
    isSavingPersistentAlarm: isSavingPersistentAlarm ?? false,
    newAlarmFormElements: AlarmFormElements(
      selectedOffsetNumber: 10,
      selectedOffsetType: AlarmOffsetType.minutes,
      isSilentAlarm: true
    ),
  ));

  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();

  void initializeWithData({
    AlarmFormElements? alarmFormElements,
    int? initialElementIndex,
    bool isSavingPersistentAlarm = false,
  }) {
    if (alarmFormElements != null) {
      emit(state.copyWith(
        isSavingPersistentAlarm: isSavingPersistentAlarm,
        initialAlarmFormElementIndex: initialElementIndex,
        newAlarmFormElements: alarmFormElements,
      ));
      selectOffsetNumber(alarmFormElements.selectedOffsetNumber.toString());
    } else {
      throw Exception("AlarmFormElements must be provided when initializing with data.");
    }
  }

  void selectOffsetNumber(String value) {
    final parsedNumber = int.tryParse(value) ?? 0;
    final number = PositiveValueValidator.dirty(parsedNumber);

    AlarmFormElements currentElements = state.newAlarmFormElements.copyWith(
      selectedOffsetNumber: number.value
    );
    emit(state.copyWith(
      newAlarmFormElements: currentElements,
      offsetNumberValidator: number,
      isValidOffsetNumber: Formz.validate([number])
    ));
    _validateForm();
  }

  void selectOffsetType(AlarmOffsetType? type) {
    AlarmFormElements currentElements = state.newAlarmFormElements.copyWith(
      selectedOffsetType: type
    );
    emit(state.copyWith(newAlarmFormElements: currentElements));
    _validateForm();
  }

  void toggleSilentAlarm(bool? isSilent) {
    AlarmFormElements currentElements = state.newAlarmFormElements.copyWith(
      isSilentAlarm: isSilent ?? true
    );
    emit(state.copyWith(newAlarmFormElements: currentElements));
  }

  void _validateForm() {
    final isValid = state.newAlarmFormElements.selectedOffsetNumber > 0;
    emit(state.copyWith(isValidAlarm: isValid));
  }

  void onSubmit() async {
    if (state.isValidAlarm) {
      AlarmFormElements newElement = state.newAlarmFormElements;

      if(state.isSavingPersistentAlarm ?? false){
        if(state.initialAlarmFormElementIndex == null){
          // Creating a new persistent alarm
          newElement = state.newAlarmFormElements.copyWith(
            scheduleId: state.scheduleId,
            createdAt: DateTime.now(),
          );
        }
          await alarmRepository.saveAlarmFormElement(
              formElements: newElement,
              scheduleId: newElement.scheduleId!
          );
      }

      emit(state.copyWith(
          newAlarmFormElements: newElement,
          hasSubmitted: true
      ));
    }
  }
}