// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteCategoryEntity _$NoteCategoryEntityFromJson(Map<String, dynamic> json) =>
    _NoteCategoryEntity(
      noteId: json['noteId'] as String,
      categoryId: json['categoryId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NoteCategoryEntityToJson(_NoteCategoryEntity instance) =>
    <String, dynamic>{
      'noteId': instance.noteId,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
