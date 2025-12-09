import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_response.freezed.dart';
part 'sync_response.g.dart';

/// Response model for synchronization from the backend
@freezed
abstract class SyncResponse with _$SyncResponse {
  const factory SyncResponse({
    /// Current server timestamp to be used as next lastSyncDate
    required DateTime serverTimestamp,

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

    /// IDs of successfully processed deletions on the server
    @Default([]) List<String> processedDeletions,

    /// Optional message from the server
    String? message,
  }) = _SyncResponse;

  factory SyncResponse.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseFromJson(json);
}

