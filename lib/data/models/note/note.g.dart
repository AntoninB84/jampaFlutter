// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteEntity _$NoteEntityFromJson(Map<String, dynamic> json) => _NoteEntity(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String?,
  isImportant: json['isImportant'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$NoteStatusEnumEnumMap, json['status']) ??
      NoteStatusEnum.todo,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  noteTypeId: json['noteTypeId'] as String?,
  noteType: json['noteType'] == null
      ? null
      : NoteTypeEntity.fromJson(json['noteType'] as Map<String, dynamic>),
  userId: json['userId'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => CategoryEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NoteEntityToJson(_NoteEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'isImportant': instance.isImportant,
      'status': _$NoteStatusEnumEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'noteTypeId': instance.noteTypeId,
      'noteType': instance.noteType,
      'userId': instance.userId,
      'categories': instance.categories,
    };

const _$NoteStatusEnumEnumMap = {
  NoteStatusEnum.todo: 'todo',
  NoteStatusEnum.done: 'done',
};
