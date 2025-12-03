// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  passwordHash: json['passwordHash'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
