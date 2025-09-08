part of 'save_recurrent_date_list_bloc.dart';

class SaveRecurrentDateListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeSaveRecurrentDateListFromMemoryState extends SaveRecurrentDateListEvent {
  InitializeSaveRecurrentDateListFromMemoryState({required this.recurrentDateElements});

  final List<RecurrenceFormElements> recurrentDateElements;

  @override
  List<Object?> get props => [recurrentDateElements];
}

/// Delete from persistent storage
final class DeletePersistentRecurrentDate extends SaveRecurrentDateListEvent {
  DeletePersistentRecurrentDate({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Remove from in-memory list only
final class RemoveRecurrentDateFromMemoryList extends SaveRecurrentDateListEvent {
  RemoveRecurrentDateFromMemoryList({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ResetSaveRecurrentDateListState extends SaveRecurrentDateListEvent {}