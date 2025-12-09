part of 'sync_bloc.dart';

/// Events for SyncBloc
abstract class SyncEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to request synchronization
class SyncRequested extends SyncEvent {}

/// Event to clear sync data (on logout)
class SyncCleared extends SyncEvent {}
