// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) =>
    _SyncResponse(
      lastSyncDate: json['lastSyncDate'] == null
          ? null
          : DateTime.parse(json['lastSyncDate'] as String),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      noteTypes:
          (json['noteTypes'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      notes:
          (json['notes'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      schedules:
          (json['schedules'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      reminders:
          (json['reminders'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      noteCategories:
          (json['noteCategories'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      deletions:
          (json['deletions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SyncResponseToJson(_SyncResponse instance) =>
    <String, dynamic>{
      'lastSyncDate': instance.lastSyncDate?.toIso8601String(),
      'categories': instance.categories,
      'noteTypes': instance.noteTypes,
      'notes': instance.notes,
      'schedules': instance.schedules,
      'reminders': instance.reminders,
      'noteCategories': instance.noteCategories,
      'deletions': instance.deletions,
      'message': instance.message,
    };
