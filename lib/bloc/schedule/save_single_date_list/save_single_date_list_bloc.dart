import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/enums/ui_list_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'save_single_date_list_event.dart';
part 'save_single_date_list_state.dart';

class SaveSingleDateListBloc extends Bloc<SaveSingleDateListEvent, SaveSingleDateListState> {
  SaveSingleDateListBloc() : super(const SaveSingleDateListState()) {
    on<ResetSaveSingleDateListState>(_resetState);
    on<InitializeSaveSingleDateListFromMemoryState>(_initializeFromMemoryState);
    on<DeletePersistentSingleDate>(_onDeletePersistentSingleDate);
    on<RemoveSingleDateFromMemoryList>(_onRemoveSingleDateFromMemoryList);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void _initializeFromMemoryState(InitializeSaveSingleDateListFromMemoryState event, Emitter<SaveSingleDateListState> emit) {
    emit(state.copyWith(singleDateElements: event.singleDateElements));
  }

  void _onDeletePersistentSingleDate(DeletePersistentSingleDate event, Emitter<SaveSingleDateListState> emit) async {
    await scheduleRepository.deleteScheduleById(event.id).then((_) {
      //TODO verify if alarms are also deleted
      // Remove from in-memory list as well
      final updatedList = List<SingleDateFormElements>.from(state.singleDateElements);
      final int index = updatedList.indexWhere((element) => element.scheduleId == event.id);
      if(index >= 0 && index < updatedList.length) {
        updatedList.removeAt(index);
        emit(state.copyWith(singleDateElements: updatedList));
      }
    });
  }

  // Remove a single date from the in-memory list based on index
  void _onRemoveSingleDateFromMemoryList(RemoveSingleDateFromMemoryList event, Emitter<SaveSingleDateListState> emit) {
    final updatedList = List<SingleDateFormElements>.from(state.singleDateElements);
    if(event.index >= 0 && event.index < updatedList.length) {
      updatedList.removeAt(event.index);
      emit(state.copyWith(singleDateElements: updatedList));
    }
  }

  void _resetState(ResetSaveSingleDateListState event, Emitter<SaveSingleDateListState> emit) {
    emit(const SaveSingleDateListState());
  }
}