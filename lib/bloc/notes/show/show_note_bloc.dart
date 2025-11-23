import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jampa_flutter/data/objects/schedule_with_next_occurrence.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/helpers/utils.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../data/models/note.dart';
import '../../../repository/schedule_repository.dart';

part 'show_note_event.dart';
part 'show_note_state.dart';

class ShowNoteBloc extends Bloc<ShowNoteEvent, ShowNoteState> {
  ShowNoteBloc() : super(ShowNoteState(
    quillController: QuillController.basic(),
  )) {
    on<GetNoteById>(_getNoteById);
    on<WatchSchedulesAndAlarmsByNoteId>(_watchSchedulesAndAlarmsByNoteId);
    on<OnChangeNoteContent>(
      _onNoteContentChanged,
      transformer: Utils.debounceTransformer(const Duration(seconds: 2))
    );
    on<DeleteNoteById>(_deleteNoteById);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  void _getNoteById(GetNoteById event, Emitter<ShowNoteState> emit) async {
    emit(state.copyWith(
      status: NoteStatus.loading,
      schedulesLoadingStatus: NoteStatus.loading,
    ));

    try {
      if(event.noteId != null) {
        // Fetching note by id
        NoteEntity? note = await notesRepository.getNoteById(event.noteId!);
        if(note != null) {
          // Setting up the Quill controller with the note content
          state.quillController.document = note.content != null
              ? Document.fromJson(jsonDecode(note.content!))
              : Document();

          // Listening to changes in the Quill controller to update note content
          state.quillController.changes.listen((event) => add(OnChangeNoteContent()));

          emit(state.copyWith(
            status: NoteStatus.success,
            note: note,
          ));
        } else {
          if(!state.deletionSuccess){
            emit(state.copyWith(status: NoteStatus.failure));
          }
        }
      } else {
        emit(state.copyWith(status: NoteStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  void _watchSchedulesAndAlarmsByNoteId(WatchSchedulesAndAlarmsByNoteId event, Emitter<ShowNoteState> emit) async {
    emit(state.copyWith(schedulesLoadingStatus: NoteStatus.loading));

    try {
      if(event.noteId != null) {
        await emit.onEach<List<ScheduleWithNextOccurrence>>(
          scheduleRepository.watchAllSchedulesAndAlarmsByNoteId(event.noteId!),
          onData: (schedulesWithNextOccurrences){
            emit(state.copyWith(
              schedulesAndReminders: schedulesWithNextOccurrences,
              schedulesLoadingStatus: NoteStatus.success,
            ));
          },
          onError: (error, stackTrace){
            debugPrint("Error watching schedules and alarms by note id: $error");
            emit(state.copyWith(schedulesLoadingStatus: NoteStatus.failure));
          }
        );
      } else {
        emit(state.copyWith(schedulesLoadingStatus: NoteStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(schedulesLoadingStatus: NoteStatus.failure));
    }
  }

  void _onNoteContentChanged(OnChangeNoteContent event, Emitter<ShowNoteState> emit) async {
    // Convert Quill document to JSON string
    String? content = state.quillController.document.isEmpty()
        ? null : jsonEncode(state.quillController.document.toDelta().toJson());

    if(state.note != null){
      await notesRepository.updateNoteContent(state.note!.id, content ?? "")
      .catchError((error){
        debugPrint("Error updating note content: $error");
      });
    }
  }

  void _deleteNoteById(DeleteNoteById event, Emitter<ShowNoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading, deletionSuccess: false, deletionFailure: false));
    try {
      if(event.noteId != null) {
        await notesRepository.deleteNoteById(event.noteId!)
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