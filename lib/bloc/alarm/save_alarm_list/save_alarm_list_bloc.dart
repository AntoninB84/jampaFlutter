import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/utils/enums/ui_list_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../notes/create/create_note_form_helpers.dart';


part 'save_alarm_list_event.dart';
part 'save_alarm_list_state.dart';

class SaveAlarmListBloc extends Bloc<SaveAlarmListEvent, SaveAlarmListState> {
  SaveAlarmListBloc() : super(const SaveAlarmListState()) {
    on<ResetSaveAlarmListState>(_resetState);
    on<InitializeSaveAlarmListFromMemoryState>(_initializeFromMemoryState);
    on<DeletePersistentAlarm>(_onDeletePersistentAlarm);
    on<RemoveAlarmFromMemoryList>(_onRemoveAlarmFromMemoryList);
  }

  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();

  void _initializeFromMemoryState(InitializeSaveAlarmListFromMemoryState event, Emitter<SaveAlarmListState> emit) {
    emit(state.copyWith(alarmElements: event.alarmElements));
  }

  void _onDeletePersistentAlarm(DeletePersistentAlarm event, Emitter<SaveAlarmListState> emit) async {
    await alarmRepository.deleteAlarmById(event.id).then((_) {
      // Remove from in-memory list as well
      final updatedList = List<AlarmFormElements>.from(state.alarmElements);
      final int index = updatedList.indexWhere((element) => element.alarmId == event.id);
      if(index >= 0 && index < updatedList.length) {
        updatedList.removeAt(index);
        emit(state.copyWith(alarmElements: updatedList));
      }
    });
  }

  // Remove a single date from the in-memory list based on index
  void _onRemoveAlarmFromMemoryList(RemoveAlarmFromMemoryList event, Emitter<SaveAlarmListState> emit) {
    final updatedList = List<AlarmFormElements>.from(state.alarmElements);
    if(event.index >= 0 && event.index < updatedList.length) {
      updatedList.removeAt(event.index);
      emit(state.copyWith(alarmElements: updatedList));
    }
  }

  void _resetState(ResetSaveAlarmListState event, Emitter<SaveAlarmListState> emit) {
    emit(const SaveAlarmListState());
  }
}