part of 'notes_list_view_bloc.dart';

class NotesListViewState extends Equatable {

  const NotesListViewState({
    this.listStatus = .initial,
    List<NoteListViewData>? notes,
  }) : notes = notes ?? const [];

  /// The current status of the notes list view.
  final UIStatusEnum listStatus;

  /// The list of notes to be displayed in the list view.
  final List<NoteListViewData> notes;


  @override
  List<Object?> get props => [listStatus, notes];

  NotesListViewState copyWith({
    List<NoteListViewData>? notes,
    UIStatusEnum? listStatus,
  }) {
    return NotesListViewState(
      notes: notes ?? this.notes,
      listStatus: listStatus ?? this.listStatus,
    );
  }
}