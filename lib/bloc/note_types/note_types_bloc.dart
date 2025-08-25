import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/note_types_repository.dart';
import 'package:jampa_flutter/data/models/note_type.dart';

part 'note_types_state.dart';
part 'note_types_event.dart';

class NoteTypesBloc extends Bloc<NoteTypesEvent, NoteTypesState> {
  NoteTypesBloc({
    required this.noteTypesRepository
  }) : super(const NoteTypesState()) {
    on<WatchNoteTypes>(_watchNoteTypes);
    on<WatchNoteTypesWithCount>(_watchNoteTypesWithCount);
    on<DeleteNoteType>(_deleteNoteType);
  }
  final NoteTypesRepository noteTypesRepository;

  void _watchNoteTypes(WatchNoteTypes event, Emitter<NoteTypesState> emit) async {
    await emit.onEach(
        noteTypesRepository.watchAllNotesTypes(),
        onData: (data) {
          emit(
              state.copyWith(
                  listStatus: NoteTypesListStatus.success,
                  noteTypes: data
              )
          );
        },
        onError: (error, stackTrace) {
          debugPrint("Error listening to noteTypes: $error");
          emit(state.copyWith(listStatus: NoteTypesListStatus.error));
        }
    );
  }

  void _watchNoteTypesWithCount(WatchNoteTypesWithCount event, Emitter<NoteTypesState> emit) async {
    await emit.onEach(
        noteTypesRepository.watchAllNotesTypesWithCount(),
        onData: (data) {
          emit(
              state.copyWith(
                  listStatus: NoteTypesListStatus.success,
                  noteTypesWithCount: data
              )
          );
        },
        onError: (error, stackTrace) {
          debugPrint("Error listening to noteTypes with count: $error");
          emit(state.copyWith(listStatus: NoteTypesListStatus.error));
        }
    );
  }

  void _deleteNoteType(DeleteNoteType event, Emitter<NoteTypesState> emit) async {
    emit(state.copyWith(deletionError: false));
    try {
      int noteTypeId = event.selectedNoteTypeId;
      await noteTypesRepository.deleteNoteType(noteTypeId);
    } catch (error) {
      emit(state.copyWith(deletionError: true));
      debugPrint("Error deleting noteType: $error");
    }
  }
}