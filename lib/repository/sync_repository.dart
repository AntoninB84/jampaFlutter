import 'package:jampa_flutter/data/sync/sync_service.dart';

/// Repository for managing synchronization operations
class SyncRepository {
  final SyncService _syncService;

  const SyncRepository({required SyncService syncService})
      : _syncService = syncService;

  /// Perform synchronization with the backend
  /// Returns true if sync was successful, false otherwise
  Future<bool> sync() async {
    return await _syncService.performSync();
  }

  /// Clear all sync data (useful for logout)
  Future<void> clearSyncData() async {
    await _syncService.clearSyncData();
  }
}

