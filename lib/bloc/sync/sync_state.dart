part of 'sync_bloc.dart';

/// States for SyncBloc
abstract class SyncState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state before any sync
class SyncInitial extends SyncState {}

/// State when sync is in progress
class SyncInProgress extends SyncState {}

/// State when sync completed successfully
class SyncSuccess extends SyncState {
  final DateTime syncDate;

  SyncSuccess(this.syncDate);

  @override
  List<Object?> get props => [syncDate];
}

/// State when sync failed
class SyncFailure extends SyncState {
  final String error;

  SyncFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// State when sync is skipped due to no network
class SyncNoNetwork extends SyncState {}