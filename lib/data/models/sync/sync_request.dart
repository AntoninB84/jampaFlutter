import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_request.freezed.dart';
part 'sync_request.g.dart';

/// Request model for synchronization with the backend
@freezed
abstract class SyncRequest with _$SyncRequest {
  const factory SyncRequest({
    /// Last sync date to get changes after this date
    DateTime? lastSyncDate,

    /// Categories created or updated since last sync
    @Default([]) List<Map<String, dynamic>> categories,

    /// Note types created or updated since last sync
    @Default([]) List<Map<String, dynamic>> noteTypes,

    /// Notes created or updated since last sync
    @Default([]) List<Map<String, dynamic>> notes,

    /// Schedules created or updated since last sync
    @Default([]) List<Map<String, dynamic>> schedules,

    /// Reminders created or updated since last sync
    @Default([]) List<Map<String, dynamic>> reminders,

    /// Note-Category relationships created or updated since last sync
    @Default([]) List<Map<String, dynamic>> noteCategories,

    /// Pending deletions to be communicated to backend
    /// Format: {"entityType": "category", "entityId": "uuid"}
    @Default([]) List<Map<String, dynamic>> deletions,
  }) = _SyncRequest;

  factory SyncRequest.fromJson(Map<String, dynamic> json) =>
      _$SyncRequestFromJson(json);
}

