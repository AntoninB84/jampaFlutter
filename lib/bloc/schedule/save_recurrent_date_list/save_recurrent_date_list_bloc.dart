import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/repository/schedule_repository.dart';
import 'package:jampa_flutter/utils/enums/ui_list_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

part 'save_recurrent_date_list_event.dart';
part 'save_recurrent_date_list_state.dart';

class SaveRecurrentDateListBloc extends Bloc<SaveRecurrentDateListEvent, SaveRecurrentDateListState> {
  SaveRecurrentDateListBloc() : super(const SaveRecurrentDateListState()) {
    on<ResetSaveRecurrentDateListState>(_resetState);
    on<InitializeSaveRecurrentDateListFromMemoryState>(_initializeFromMemoryState);
    on<DeletePersistentRecurrentDate>(_onDeletePersistentRecurrentDate);
    on<RemoveRecurrentDateFromMemoryList>(_onRemoveSingleDateFromMemoryList);
  }

  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void _initializeFromMemoryState(InitializeSaveRecurrentDateListFromMemoryState event, Emitter<SaveRecurrentDateListState> emit) {
    emit(state.copyWith(recurrentDateElements: event.recurrentDateElements));
  }

  void _onDeletePersistentRecurrentDate(DeletePersistentRecurrentDate event, Emitter<SaveRecurrentDateListState> emit) async {
    await scheduleRepository.deleteScheduleById(event.id).then((_) {
      //TODO verify if alarms are also deleted
      // Remove from in-memory list as well
      final updatedList = List<RecurrenceFormElements>.from(state.recurrentDateElements);
      final int index = updatedList.indexWhere((element) => element.scheduleId == event.id);
      if(index >= 0 && index < updatedList.length) {
        updatedList.removeAt(index);
        emit(state.copyWith(recurrentDateElements: updatedList));
      }
    });
  }

  // Remove a single date from the in-memory list based on index
  void _onRemoveSingleDateFromMemoryList(RemoveRecurrentDateFromMemoryList event, Emitter<SaveRecurrentDateListState> emit) {
    final updatedList = List<RecurrenceFormElements>.from(state.recurrentDateElements);
    if(event.index >= 0 && event.index < updatedList.length) {
      updatedList.removeAt(event.index);
      emit(state.copyWith(recurrentDateElements: updatedList));
    }
  }

  void _resetState(ResetSaveRecurrentDateListState event, Emitter<SaveRecurrentDateListState> emit) {
    emit(const SaveRecurrentDateListState());
  }
}