import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/notes_list_view_repository.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/utils/enums/note_status_enum.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../utils/enums/ui_status.dart';

part 'notes_list_view_event.dart';
part 'notes_list_view_state.dart';

/// Bloc for managing the state of the notes list.
/// Handles events related to watching and updating the notes list.
/// Based on the database view 'notes_list_view'.
class NotesListViewBloc extends Bloc<NotesListViewEvent, NotesListViewState> {
  NotesListViewBloc() : super(const NotesListViewState()) {
    on<WatchNotes>(_watchNotesList);
  }
  final NotesListViewRepository notesListViewRepository =
      serviceLocator<NotesListViewRepository>();

  /// Watches the notes list and updates the state accordingly.
  void _watchNotesList(WatchNotes event, Emitter<NotesListViewState> emit) async {
    emit(state.copyWith(listStatus: .loading));
    await emit.onEach(
        notesListViewRepository.watchNotesWithFilters(
          noteTypeId: null,
          categoryIds: null,
          statuses: [NoteStatusEnum.todo]
        ),
        onData: (data) {
          emit(
              state.copyWith(
                  listStatus: .success,
                  notes: data
              )
          );
        },
        onError: (error, stackTrace) {
          debugPrint("Error listening to notes: $error");
          emit(state.copyWith(listStatus: .failure));
        }
    );
  }
}