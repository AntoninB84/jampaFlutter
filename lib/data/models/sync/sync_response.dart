import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_response.freezed.dart';
part 'sync_response.g.dart';

/// Response model for synchronization from the backend
@freezed
abstract class SyncResponse with _$SyncResponse {
  const factory SyncResponse({
    /// Current server timestamp to be used as next lastSyncDate
    /// If null, uses current client time
    DateTime? lastSyncDate,

    /// Categories from the server (created or updated since lastSyncDate)
    @Default([]) List<Map<String, dynamic>> categories,

    /// Note types from the server
    @Default([]) List<Map<String, dynamic>> noteTypes,

    /// Notes from the server
    @Default([]) List<Map<String, dynamic>> notes,

    /// Schedules from the server
    @Default([]) List<Map<String, dynamic>> schedules,

    /// Reminders from the server
    @Default([]) List<Map<String, dynamic>> reminders,

    /// Note-Category relationships from the server
    @Default([]) List<Map<String, dynamic>> noteCategories,

    /// Deletions from the server (entities that were deleted on backend)
    /// Format: [{"entityType": "note", "entityId": "uuid"}, ...]
    @Default([])
    @JsonKey(fromJson: _deletionsFromJson, toJson: _deletionsToJson)
    List<Map<String, dynamic>> deletions,

    /// Optional message from the server
    String? message,
  }) = _SyncResponse;

  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}

/// Custom fromJson for deletions to ensure proper parsing
List<Map<String, dynamic>> _deletionsFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json.map((e) => e as Map<String, dynamic>).toList();
  }
  return [];
}

/// Custom toJson for deletions
List<Map<String, dynamic>> _deletionsToJson(List<Map<String, dynamic>> deletions) => deletions;

