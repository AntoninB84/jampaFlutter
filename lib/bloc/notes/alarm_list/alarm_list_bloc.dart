import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/alarm_repository.dart';
import 'package:jampa_flutter/utils/enums/ui_list_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../create/create_note_form_helpers.dart';

part 'alarm_list_event.dart';
part 'alarm_list_state.dart';

class AlarmListBloc extends Bloc<AlarmListEvent, AlarmListState> {
  AlarmListBloc() : super(const AlarmListState()) {
    on<ResetAlarmListState>(_resetState);
    on<InitializeAlarmListFromMemoryState>(_initializeFromMemoryState);
    on<LoadPersistentAlarmList>(_onLoadPersistentAlarmList);
    on<DeletePersistentAlarm>(_onDeletePersistentAlarm);
    on<RemoveAlarmFromMemoryList>(_onRemoveAlarmFromMemoryList);
  }

  final AlarmRepository alarmRepository = serviceLocator<AlarmRepository>();

  void _initializeFromMemoryState(InitializeAlarmListFromMemoryState event, Emitter<AlarmListState> emit) {
    emit(state.copyWith(alarmElements: event.alarmElements));
  }

  void _onLoadPersistentAlarmList(LoadPersistentAlarmList event, Emitter<AlarmListState> emit) {

  }

  void _onDeletePersistentAlarm(DeletePersistentAlarm event, Emitter<AlarmListState> emit) async {
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
  void _onRemoveAlarmFromMemoryList(RemoveAlarmFromMemoryList event, Emitter<AlarmListState> emit) {
    final updatedList = List<AlarmFormElements>.from(state.alarmElements);
    if(event.index >= 0 && event.index < updatedList.length) {
      updatedList.removeAt(event.index);
      emit(state.copyWith(alarmElements: updatedList));
    }
  }

  void _resetState(ResetAlarmListState event, Emitter<AlarmListState> emit) {
    emit(const AlarmListState());
  }
}