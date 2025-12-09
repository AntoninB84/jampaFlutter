// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReminderEntity _$ReminderEntityFromJson(Map<String, dynamic> json) =>
    _ReminderEntity(
      id: json['id'] as String,
      scheduleId: json['scheduleId'] as String,
      noteId: json['noteId'] as String,
      offsetValue: (json['offsetValue'] as num).toInt(),
      offsetType: $enumDecode(_$ReminderOffsetTypeEnumMap, json['offsetType']),
      isNotification: json['isNotification'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReminderEntityToJson(_ReminderEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'noteId': instance.noteId,
      'offsetValue': instance.offsetValue,
      'offsetType': _$ReminderOffsetTypeEnumMap[instance.offsetType]!,
      'isNotification': instance.isNotification,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ReminderOffsetTypeEnumMap = {
  ReminderOffsetType.minutes: 'minutes',
  ReminderOffsetType.hours: 'hours',
  ReminderOffsetType.days: 'days',
};
