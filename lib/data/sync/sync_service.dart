import 'package:jampa_flutter/data/api/sync_api_client.dart';
import 'package:jampa_flutter/data/database.dart';
import 'package:jampa_flutter/data/models/category/category.dart';
import 'package:jampa_flutter/data/models/note/note.dart';
import 'package:jampa_flutter/data/models/note_category/note_category.dart';
import 'package:jampa_flutter/data/models/note_type/note_type.dart';
import 'package:jampa_flutter/data/models/reminder/reminder.dart';
import 'package:jampa_flutter/data/models/schedule/schedule.dart';
import 'package:jampa_flutter/data/models/sync/sync_request.dart';
import 'package:jampa_flutter/data/models/sync/sync_response.dart';
import 'package:jampa_flutter/utils/storage/sync_storage_service.dart';
import 'package:drift/drift.dart';

/// Service to handle synchronization with the backend
class SyncService {
  final SyncApiClient _apiClient;
  final SyncStorageService _storageService;
  final AppDatabase _database;

  SyncService({
    required SyncApiClient apiClient,
    required SyncStorageService storageService,
    required AppDatabase database,
  })  : _apiClient = apiClient,
        _storageService = storageService,
        _database = database;

  /// Perform full synchronization with the backend
  /// Returns true if sync was successful, false otherwise
  Future<bool> performSync() async {
    try {
      // Get last sync date
      final lastSyncDate = _storageService.getLastSyncDate();

      // Prepare sync request with local changes
      final request = await _prepareSyncRequest(lastSyncDate);

      // Send sync request to backend
      final response = await _apiClient.sync(request);

      // Process sync response and update local database
      await _processSyncResponse(response);

      // Update last sync date - use server timestamp if available, otherwise use current time
      final syncTimestamp = response.lastSyncDate ?? DateTime.now();
      await _storageService.saveLastSyncDate(syncTimestamp);

      // Clear processed deletions
      // Extract entityIds from deletions to track what was processed
      if (response.deletions.isNotEmpty) {
        final deletionIds = response.deletions
            .map((d) => d['entityId'] as String?)
            .where((id) => id != null)
            .cast<String>()
            .toList();
        if (deletionIds.isNotEmpty) {
          await _storageService.removePendingDeletions(deletionIds);
        }
      }

      return true;
    } catch (e) {
      // Log error or handle it appropriately
      // TODO: Replace with proper logging in production
      // ignore: avoid_print
      print('Sync failed: $e');
      return false;
    }
  }

  /// Prepare sync request with local changes since last sync
  Future<SyncRequest> _prepareSyncRequest(DateTime? lastSyncDate) async {
    final deletions = _storageService.getPendingDeletionsByType();
    final deletionsList = deletions.entries
        .expand((entry) => entry.value.map((id) => {
              'entityType': entry.key,
              'entityId': id,
            }))
        .toList();

    // Get local changes since lastSyncDate
    // Get local changes since lastSyncDate
    final categories = await _getChangedCategories(lastSyncDate);
    final noteTypes = await _getChangedNoteTypes(lastSyncDate);
    final notes = await _getChangedNotes(lastSyncDate);
    final schedules = await _getChangedSchedules(lastSyncDate);
    final reminders = await _getChangedReminders(lastSyncDate);
    final noteCategories = await _getChangedNoteCategories(lastSyncDate);

    return SyncRequest(
      lastSyncDate: lastSyncDate,
      categories: categories.map((e) => e.toJson()).toList(),
      noteTypes: noteTypes.map((e) => e.toJson()).toList(),
      notes: notes.map((e) => e.toJson()).toList(),
      schedules: schedules.map((e) => e.toJson()).toList(),
      reminders: reminders.map((e) => e.toJson()).toList(),
      noteCategories: noteCategories.map((e) => e.toJson()).toList(),
      deletions: deletionsList,
    );
  }

  /// Get categories changed since lastSyncDate
  Future<List<CategoryEntity>> _getChangedCategories(DateTime? lastSyncDate) async {
    if (lastSyncDate == null) {
      // First sync - get all categories
      return await (_database.select(_database.categoryTable).get());
    }

    // Get categories updated after lastSyncDate
    return await (_database.select(_database.categoryTable)
          ..where((tbl) => tbl.updatedAt.isBiggerThanValue(lastSyncDate)))
        .get();
  }

  /// Get note types changed since lastSyncDate
  Future<List<NoteTypeEntity>> _getChangedNoteTypes(DateTime? lastSyncDate) async {
    if (lastSyncDate == null) {
      return await (_database.select(_database.noteTypeTable).get());
    }

    return await (_database.select(_database.noteTypeTable)
          ..where((tbl) => tbl.updatedAt.isBiggerThanValue(lastSyncDate)))
        .get();
  }

  /// Get notes changed since lastSyncDate
  Future<List<NoteEntity>> _getChangedNotes(DateTime? lastSyncDate) async {
    if (lastSyncDate == null) {
      return await (_database.select(_database.noteTable).get());
    }

    return await (_database.select(_database.noteTable)
          ..where((tbl) => tbl.updatedAt.isBiggerThanValue(lastSyncDate)))
        .get();
  }

  /// Get schedules changed since lastSyncDate
  Future<List<ScheduleEntity>> _getChangedSchedules(DateTime? lastSyncDate) async {
    if (lastSyncDate == null) {
      return await (_database.select(_database.scheduleTable).get());
    }

    return await (_database.select(_database.scheduleTable)
          ..where((tbl) => tbl.updatedAt.isBiggerThanValue(lastSyncDate)))
        .get();
  }

  /// Get reminders changed since lastSyncDate
  Future<List<ReminderEntity>> _getChangedReminders(DateTime? lastSyncDate) async {
    if (lastSyncDate == null) {
      return await (_database.select(_database.reminderTable).get());
    }

    return await (_database.select(_database.reminderTable)
          ..where((tbl) => tbl.updatedAt.isBiggerThanValue(lastSyncDate)))
        .get();
  }

  /// Get note categories changed since lastSyncDate
  Future<List<NoteCategoryEntity>> _getChangedNoteCategories(DateTime? lastSyncDate) async {
    if (lastSyncDate == null) {
      // First sync - get all note categories
      return await (_database.select(_database.noteCategoryTable).get());
    }

    // Get note categories updated after lastSyncDate
    return await (_database.select(_database.noteCategoryTable)
          ..where((tbl) => tbl.updatedAt.isBiggerThanValue(lastSyncDate)))
        .get();
  }

  /// Process sync response and update local database
  Future<void> _processSyncResponse(SyncResponse response) async {
    // First, process deletions from the server
    await _processDeletions(response.deletions);

    // Process categories
    for (final categoryJson in response.categories) {
      final deletedAt = categoryJson['deletedAt'];
      if (deletedAt != null) {
        // Delete locally if soft deleted on backend
        final id = categoryJson['id'] as String;
        (_database.delete(_database.categoryTable)
          ..where((tbl) => tbl.id.equals(id))).go();
      } else {
        // Insert or update
        final category = CategoryEntity.fromJson(categoryJson);
        await _database.into(_database.categoryTable).insertOnConflictUpdate(
          category.toCompanion(),
        );
      }
    }

    // Process note types
    for (final noteTypeJson in response.noteTypes) {
      final deletedAt = noteTypeJson['deletedAt'];
      if (deletedAt != null) {
        final id = noteTypeJson['id'] as String;
        await (_database.delete(_database.noteTypeTable)
          ..where((tbl) => tbl.id.equals(id))).go();
      } else {
        final noteType = NoteTypeEntity.fromJson(noteTypeJson);
        await _database.into(_database.noteTypeTable).insertOnConflictUpdate(
          noteType.toCompanion(),
        );
      }
    }

    // Process notes
    for (final noteJson in response.notes) {
      final deletedAt = noteJson['deletedAt'];
      if (deletedAt != null) {
        final id = noteJson['id'] as String;
        await (_database.delete(_database.noteTable)
          ..where((tbl) => tbl.id.equals(id))).go();
      } else {
        final note = NoteEntity.fromJson(noteJson);
        await _database.into(_database.noteTable).insertOnConflictUpdate(
          note.toCompanion(),
        );
      }
    }

    // Process schedules
    for (final scheduleJson in response.schedules) {
      final deletedAt = scheduleJson['deletedAt'];
      if (deletedAt != null) {
        final id = scheduleJson['id'] as String;
        await (_database.delete(_database.scheduleTable)
          ..where((tbl) => tbl.id.equals(id))).go();
      } else {
        final schedule = ScheduleEntity.fromJson(scheduleJson);
        await _database.into(_database.scheduleTable).insertOnConflictUpdate(
          schedule.toCompanion(),
        );
      }
    }

    // Process reminders
    for (final reminderJson in response.reminders) {
      final deletedAt = reminderJson['deletedAt'];
      if (deletedAt != null) {
        final id = reminderJson['id'] as String;
        await (_database.delete(_database.reminderTable)
          ..where((tbl) => tbl.id.equals(id))).go();
      } else {
        final reminder = ReminderEntity.fromJson(reminderJson);
        await _database.into(_database.reminderTable).insertOnConflictUpdate(
          reminder.toCompanion(),
        );
      }
    }

    // Process note categories (junction table)
    for (final noteCategoryJson in response.noteCategories) {
      final deletedAt = noteCategoryJson['deletedAt'];
      if (deletedAt != null) {
        // Delete the relationship
        final noteId = noteCategoryJson['noteId'] as String;
        final categoryId = noteCategoryJson['categoryId'] as String;
        await (_database.delete(_database.noteCategoryTable)
          ..where((tbl) => tbl.noteId.equals(noteId) & tbl.categoryId.equals(categoryId))).go();
      } else {
        // Insert or update the relationship
        final noteCategory = NoteCategoryEntity.fromJson(noteCategoryJson);
        await _database.into(_database.noteCategoryTable).insertOnConflictUpdate(
          noteCategory.toCompanion(),
        );
      }
    }
  }

  /// Process deletions sent from the server
  /// Deletions are in format: [{"entityType": "note", "entityId": "uuid"}, ...]
  Future<void> _processDeletions(List<Map<String, dynamic>> deletions) async {
    for (final deletion in deletions) {
      final entityType = deletion['entityType'] as String;
      final entityId = deletion['entityId'] as String;

      // Delete the entity from the appropriate table based on type
      switch (entityType) {
        case 'category':
          await (_database.delete(_database.categoryTable)
            ..where((tbl) => tbl.id.equals(entityId))).go();
          break;
        case 'noteType':
          await (_database.delete(_database.noteTypeTable)
            ..where((tbl) => tbl.id.equals(entityId))).go();
          break;
        case 'note':
          await (_database.delete(_database.noteTable)
            ..where((tbl) => tbl.id.equals(entityId))).go();
          break;
        case 'schedule':
          await (_database.delete(_database.scheduleTable)
            ..where((tbl) => tbl.id.equals(entityId))).go();
          break;
        case 'reminder':
          await (_database.delete(_database.reminderTable)
            ..where((tbl) => tbl.id.equals(entityId))).go();
          break;
        case 'noteCategory':
          // For noteCategory, entityId might be a composite key
          // Format could be "noteId:categoryId" or separate handling needed
          final parts = entityId.split(':');
          if (parts.length == 2) {
            await (_database.delete(_database.noteCategoryTable)
              ..where((tbl) => tbl.noteId.equals(parts[0]) & tbl.categoryId.equals(parts[1]))).go();
          }
          break;
        default:
          print('Unknown entity type for deletion: $entityType');
      }
    }
  }

  /// Clear all sync data (useful for logout)
  Future<void> clearSyncData() async {
    await _storageService.clearAllSyncData();
  }
}

