import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jampa_flutter/data/objects/schedule_with_next_occurrence.dart';
import 'package:jampa_flutter/repository/notes_repository.dart';
import 'package:jampa_flutter/utils/enums/note_status_enum.dart';
import 'package:jampa_flutter/utils/enums/ui_status.dart';
import 'package:jampa_flutter/utils/helpers/utils.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../../../data/models/note.dart';
import '../../../repository/schedule_repository.dart';

part 'show_note_event.dart';
part 'show_note_state.dart';

/// Bloc for managing the state of showing a note
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
    on<ChangeNoteStatus>(_changeNoteStatus);
    on<DeleteNoteById>(_deleteNoteById);
  }

  final NotesRepository notesRepository = serviceLocator<NotesRepository>();
  final ScheduleRepository scheduleRepository = serviceLocator<ScheduleRepository>();

  /// Fetches a note by its ID and updates the state accordingly
  void _getNoteById(GetNoteById event, Emitter<ShowNoteState> emit) async {
    emit(state.copyWith(
      status: .loading,
      schedulesLoadingStatus: .loading,
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
            status: .success,
            note: note,
          ));
        } else {
          if(!state.noteDeletionStatus.isSuccess){
            emit(state.copyWith(status: .failure));
          }
        }
      } else {
        emit(state.copyWith(status: .failure));
      }
    } catch (e) {
      emit(state.copyWith(status: .failure));
    }
  }

  /// Watches schedules and alarms associated with a specific note ID
  void _watchSchedulesAndAlarmsByNoteId(WatchSchedulesAndAlarmsByNoteId event, Emitter<ShowNoteState> emit) async {
    emit(state.copyWith(schedulesLoadingStatus: .loading));

    try {
      if(event.noteId != null) {
        await emit.onEach<List<ScheduleWithNextOccurrence>>(
          scheduleRepository.watchAllSchedulesAndAlarmsByNoteId(event.noteId!),
          onData: (schedulesWithNextOccurrences){
            emit(state.copyWith(
              schedulesAndReminders: schedulesWithNextOccurrences,
              schedulesLoadingStatus: .success,
            ));
          },
          onError: (error, stackTrace){
            debugPrint("Error watching schedules and alarms by note id: $error");
            emit(state.copyWith(schedulesLoadingStatus: .failure));
          }
        );
      } else {
        emit(state.copyWith(schedulesLoadingStatus: .failure));
      }
    } catch (e) {
      emit(state.copyWith(schedulesLoadingStatus: .failure));
    }
  }

  /// Handles changes to the note content and updates the database accordingly
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


  /// Changes the note status
  void _changeNoteStatus(ChangeNoteStatus event, Emitter<ShowNoteState> emit) async {
    NoteEntity? note = state.note ?? await notesRepository.getNoteById(event.noteId ?? '');

    if(note != null){
      note = note.copyWith(status: event.newStatus);
      await notesRepository.saveNote(note)
      .then((_){
        emit(state.copyWith(
          noteStatusChangeStatus: .success,
          note: note,
        ));
      })
      .catchError((error){
        emit(state.copyWith(noteStatusChangeStatus: .failure));
        debugPrint("Error updating note status: $error");
      });
    } else {
      emit(state.copyWith(noteStatusChangeStatus: .failure));
      debugPrint("Note not found for status update");
    }
  }

  /// Deletes a note by its ID and updates the state accordingly
  void _deleteNoteById(DeleteNoteById event, Emitter<ShowNoteState> emit) async {
    emit(state.copyWith(status: .loading, noteDeletionStatus: .initial));
    try {
      if(event.noteId != null) {
        await notesRepository.deleteNoteById(event.noteId!)
        .then((_){
          emit(state.copyWith(noteDeletionStatus: .success));
        }).catchError((error){
          debugPrint("Error deleting note by id: $error");
          emit(state.copyWith(noteDeletionStatus: .failure));
        });
      } else {
        emit(state.copyWith(noteDeletionStatus: .failure));
      }
    } catch (e) {
      emit(state.copyWith(noteDeletionStatus: .failure));
    }
  }
}