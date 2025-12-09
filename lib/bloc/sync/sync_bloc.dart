 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jampa_flutter/repository/sync_repository.dart';
import 'package:jampa_flutter/utils/connectivity/connectivity_service.dart';
import 'package:equatable/equatable.dart';

part 'sync_state.dart';
part 'sync_event.dart';

/// BLoC for handling synchronization
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncRepository _syncRepository;
  final ConnectivityService _connectivityService;

  SyncBloc({
    required SyncRepository syncRepository,
    required ConnectivityService connectivityService,
  })  : _syncRepository = syncRepository,
        _connectivityService = connectivityService,
        super(SyncInitial()) {
    on<SyncRequested>(_onSyncRequested);
    on<SyncCleared>(_onSyncCleared);
  }

  Future<void> _onSyncRequested(
    SyncRequested event,
    Emitter<SyncState> emit,
  ) async {
    // Check network connectivity first
    final hasNetwork = await _connectivityService.hasNetworkConnection();

    if (!hasNetwork) {
      emit(SyncNoNetwork());
      return;
    }

    emit(SyncInProgress());

    try {
      final success = await _syncRepository.sync();

      if (success) {
        emit(SyncSuccess(DateTime.now()));
      } else {
        emit(SyncFailure('Sync failed'));
      }
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }

  Future<void> _onSyncCleared(
    SyncCleared event,
    Emitter<SyncState> emit,
  ) async {
    try {
      await _syncRepository.clearSyncData();
      emit(SyncInitial());
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }
}

