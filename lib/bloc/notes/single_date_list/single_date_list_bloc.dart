import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/enums/ui_list_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'single_date_list_event.dart';
part 'single_date_list_state.dart';

class SingleDateListBloc extends Bloc<SingleDateListEvent, SingleDateListState> {
  SingleDateListBloc() : super(const SingleDateListState()) {
    on<ResetSingleDateListState>(_resetState);
    on<InitializeSingleDateListFromMemoryState>(_initializeFromMemoryState);
    on<LoadPersistentSingleDateList>(_onLoadPersistentSingleDateList);
    on<DeletePersistentSingleDate>(_onDeletePersistentSingleDate);
    on<RemoveSingleDateFromMemoryList>(_onRemoveSingleDateFromMemoryList);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void _initializeFromMemoryState(InitializeSingleDateListFromMemoryState event, Emitter<SingleDateListState> emit) {
    emit(state.copyWith(singleDateElements: event.singleDateElements));
  }

  void _onLoadPersistentSingleDateList(LoadPersistentSingleDateList event, Emitter<SingleDateListState> emit) {

  }

  void _onDeletePersistentSingleDate(DeletePersistentSingleDate event, Emitter<SingleDateListState> emit) async {
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
  void _onRemoveSingleDateFromMemoryList(RemoveSingleDateFromMemoryList event, Emitter<SingleDateListState> emit) {
    final updatedList = List<SingleDateFormElements>.from(state.singleDateElements);
    if(event.index >= 0 && event.index < updatedList.length) {
      updatedList.removeAt(event.index);
      emit(state.copyWith(singleDateElements: updatedList));
    }
  }

  void _resetState(ResetSingleDateListState event, Emitter<SingleDateListState> emit) {
    emit(const SingleDateListState());
  }
}