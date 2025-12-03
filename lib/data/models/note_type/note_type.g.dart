// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteTypeEntity _$NoteTypeEntityFromJson(Map<String, dynamic> json) =>
    _NoteTypeEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NoteTypeEntityToJson(_NoteTypeEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
