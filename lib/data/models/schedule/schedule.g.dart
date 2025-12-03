// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleEntity _$ScheduleEntityFromJson(Map<String, dynamic> json) =>
    _ScheduleEntity(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      startDateTime: json['startDateTime'] == null
          ? null
          : DateTime.parse(json['startDateTime'] as String),
      endDateTime: json['endDateTime'] == null
          ? null
          : DateTime.parse(json['endDateTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      recurrenceType: $enumDecodeNullable(
        _$RecurrenceTypeEnumMap,
        json['recurrenceType'],
      ),
      recurrenceInterval: (json['recurrenceInterval'] as num?)?.toInt(),
      recurrenceDay: (json['recurrenceDay'] as num?)?.toInt(),
      recurrenceEndDate: json['recurrenceEndDate'] == null
          ? null
          : DateTime.parse(json['recurrenceEndDate'] as String),
    );

Map<String, dynamic> _$ScheduleEntityToJson(_ScheduleEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'startDateTime': instance.startDateTime?.toIso8601String(),
      'endDateTime': instance.endDateTime?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType],
      'recurrenceInterval': instance.recurrenceInterval,
      'recurrenceDay': instance.recurrenceDay,
      'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.intervalDays: 'intervalDays',
  RecurrenceType.intervalYears: 'intervalYears',
  RecurrenceType.dayBasedWeekly: 'dayBasedWeekly',
  RecurrenceType.dayBasedMonthly: 'dayBasedMonthly',
};
