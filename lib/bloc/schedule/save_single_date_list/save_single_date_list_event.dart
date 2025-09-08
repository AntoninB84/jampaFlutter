part of 'save_single_date_list_bloc.dart';

class SaveSingleDateListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeSaveSingleDateListFromMemoryState extends SaveSingleDateListEvent {
  InitializeSaveSingleDateListFromMemoryState({required this.singleDateElements});

  final List<SingleDateFormElements> singleDateElements;

  @override
  List<Object?> get props => [singleDateElements];
}

/// Delete from persistent storage
final class DeletePersistentSingleDate extends SaveSingleDateListEvent {
  DeletePersistentSingleDate({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Remove from in-memory list only
final class RemoveSingleDateFromMemoryList extends SaveSingleDateListEvent {
  RemoveSingleDateFromMemoryList({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ResetSaveSingleDateListState extends SaveSingleDateListEvent {}