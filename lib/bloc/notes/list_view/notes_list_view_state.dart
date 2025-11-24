part of 'notes_list_view_bloc.dart';

enum NotesListStatus {
  initial,
  success,
  error,
  loading,
}

extension NotesListStatusX on NotesListStatus {
  bool get isInitial => this == NotesListStatus.initial;
  bool get isSuccess => this == NotesListStatus.success;
  bool get isError => this == NotesListStatus.error;
  bool get isLoading => this == NotesListStatus.loading;
}

class NotesListViewState extends Equatable {

  const NotesListViewState({
    this.listStatus = NotesListStatus.initial,
    List<NoteListViewData>? notes,
  }) : notes = notes ?? const [];

  /// The current status of the notes list view.
  final NotesListStatus listStatus;

  /// The list of notes to be displayed in the list view.
  final List<NoteListViewData> notes;


  @override
  List<Object?> get props => [listStatus, notes];

  NotesListViewState copyWith({
    List<NoteListViewData>? notes,
    NotesListStatus? listStatus,
  }) {
    return NotesListViewState(
      notes: notes ?? this.notes,
      listStatus: listStatus ?? this.listStatus,
    );
  }
}