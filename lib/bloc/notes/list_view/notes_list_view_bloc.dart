import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/notes_list_view_repository.dart';
import 'package:jampa_flutter/data/database.dart';

part 'notes_list_view_event.dart';
part 'notes_list_view_state.dart';

class NotesListViewBloc extends Bloc<NotesListViewEvent, NotesListViewState> {
  NotesListViewBloc({
    required this.notesListViewRepository
  }) : super(const NotesListViewState()) {
    on<WatchNotes>(_watchNotesList);
  }
  final NotesListViewRepository notesListViewRepository;

  void _watchNotesList(WatchNotes event, Emitter<NotesListViewState> emit) async {
    await emit.onEach(
        notesListViewRepository.watchNotesWithFilters(null, null),
        onData: (data) {
          emit(
              state.copyWith(
                  listStatus: NotesListStatus.success,
                  notes: data
              )
          );
        },
        onError: (error, stackTrace) {
          debugPrint("Error listening to notes: $error");
          emit(state.copyWith(listStatus: NotesListStatus.error));
        }
    );
  }

}