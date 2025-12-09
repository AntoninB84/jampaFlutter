import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle sync-related storage operations
class SyncStorageService {
  final SharedPreferences _prefs;

  static const String _lastSyncDateKey = 'LAST_SYNC_DATE';
  static const String _pendingDeletionsKey = 'PENDING_DELETIONS';

  SyncStorageService({required SharedPreferences prefs}) : _prefs = prefs;

  /// Store the last sync date
  Future<void> saveLastSyncDate(DateTime date) async {
    await _prefs.setString(_lastSyncDateKey, date.toIso8601String());
  }

  /// Retrieve the last sync date
  DateTime? getLastSyncDate() {
    final dateString = _prefs.getString(_lastSyncDateKey);
    if (dateString == null) return null;
    return DateTime.tryParse(dateString);
  }

  /// Clear the last sync date
  Future<void> clearLastSyncDate() async {
    await _prefs.remove(_lastSyncDateKey);
  }

  /// Add a pending deletion to the list
  /// Format: "entityType:entityId"
  Future<void> addPendingDeletion(String entityType, String entityId) async {
    final deletions = getPendingDeletions();
    final key = '$entityType:$entityId';
    if (!deletions.contains(key)) {
      deletions.add(key);
      await _prefs.setStringList(_pendingDeletionsKey, deletions);
    }
  }

  /// Get all pending deletions
  List<String> getPendingDeletions() {
    return _prefs.getStringList(_pendingDeletionsKey) ?? [];
  }

  /// Clear pending deletions
  Future<void> clearPendingDeletions() async {
    await _prefs.remove(_pendingDeletionsKey);
  }

  /// Remove specific pending deletions
  Future<void> removePendingDeletions(List<String> deletions) async {
    final allDeletions = getPendingDeletions();
    allDeletions.removeWhere((item) => deletions.contains(item));
    if (allDeletions.isEmpty) {
      await clearPendingDeletions();
    } else {
      await _prefs.setStringList(_pendingDeletionsKey, allDeletions);
    }
  }

  /// Get pending deletions grouped by entity type
  Map<String, List<String>> getPendingDeletionsByType() {
    final deletions = getPendingDeletions();
    final Map<String, List<String>> grouped = {};

    for (final deletion in deletions) {
      final parts = deletion.split(':');
      if (parts.length == 2) {
        final type = parts[0];
        final id = parts[1];
        grouped.putIfAbsent(type, () => []).add(id);
      }
    }

    return grouped;
  }

  /// Clear all sync data
  Future<void> clearAllSyncData() async {
    await Future.wait([
      clearLastSyncDate(),
      clearPendingDeletions(),
    ]);
  }
}

