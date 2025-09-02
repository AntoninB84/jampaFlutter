import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../data/models/note.dart';

part 'note_state.dart';
part 'note_event.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(const NoteState()) {
    on<WatchNoteById>(_watchNoteById);
    on<DeleteNoteById>(_deleteNoteById);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();

  void _watchNoteById(WatchNoteById event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      if(event.noteId != null) {
        String noteId = event.noteId!;

        await emit.onEach<NoteEntity?>(
          notesRepository.watchNoteById(int.parse(noteId)),
          onData: (note) {
            if(note != null) {
              emit(state.copyWith(status: NoteStatus.success, note: note));
            } else {
              if(!state.deletionSuccess){
                emit(state.copyWith(status: NoteStatus.failure));
              }
            }
          },
          onError: (error, stackTrace) {
            debugPrint("Error watching note by id: $error");
            emit(state.copyWith(status: NoteStatus.failure));
          }
        );
      } else {
        emit(state.copyWith(status: NoteStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  void _deleteNoteById(DeleteNoteById event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading, deletionSuccess: false, deletionFailure: false));
    try {
      if(event.noteId != null) {
        int noteId = event.noteId!;

        await notesRepository.deleteNoteById(noteId)
        .then((_){
          emit(state.copyWith(deletionSuccess: true));
        }).catchError((error){
          debugPrint("Error deleting note by id: $error");
          emit(state.copyWith(deletionFailure: true));
        });
      } else {
        emit(state.copyWith(deletionFailure: true));
      }
    } catch (e) {
      emit(state.copyWith(deletionFailure: true));
    }
  }
}