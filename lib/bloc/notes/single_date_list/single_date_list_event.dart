part of 'single_date_list_bloc.dart';

class SingleDateListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class InitializeSingleDateListFromMemoryState extends SingleDateListEvent {
  InitializeSingleDateListFromMemoryState({required this.singleDateElements});

  final List<SingleDateFormElements> singleDateElements;

  @override
  List<Object?> get props => [singleDateElements];
}

final class LoadPersistentSingleDateList extends SingleDateListEvent {}

/// Delete from persistent storage
final class DeletePersistentSingleDate extends SingleDateListEvent {
  DeletePersistentSingleDate({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Remove from in-memory list only
final class RemoveSingleDateFromMemoryList extends SingleDateListEvent {
  RemoveSingleDateFromMemoryList({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class ResetSingleDateListState extends SingleDateListEvent {}