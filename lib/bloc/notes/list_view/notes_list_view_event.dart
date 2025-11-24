part of 'notes_list_view_bloc.dart';

class NotesListViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to watch notes updates and reflect changes in the list view.
final class WatchNotes extends NotesListViewEvent {}
