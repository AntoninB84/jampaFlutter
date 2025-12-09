// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) =>
    _SyncResponse(
      serverTimestamp: DateTime.parse(json['serverTimestamp'] as String),
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
      processedDeletions:
          (json['processedDeletions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SyncResponseToJson(_SyncResponse instance) =>
    <String, dynamic>{
      'serverTimestamp': instance.serverTimestamp.toIso8601String(),
      'categories': instance.categories,
      'noteTypes': instance.noteTypes,
      'notes': instance.notes,
      'schedules': instance.schedules,
      'reminders': instance.reminders,
      'noteCategories': instance.noteCategories,
      'processedDeletions': instance.processedDeletions,
      'message': instance.message,
    };
