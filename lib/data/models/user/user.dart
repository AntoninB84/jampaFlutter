
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../database.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Represents the 'user' table in the database.
@drift.UseRowClass(UserEntity)
class UserTable extends drift.Table {
  drift.TextColumn get id => text()();
  drift.TextColumn get username => text().withLength(min: 1, max: 50)();
  drift.TextColumn get email => text().withLength(min: 1, max: 100)();
  drift.DateTimeColumn get createdAt => dateTime().withDefault(drift.currentDateAndTime)();
  drift.DateTimeColumn get updatedAt => dateTime().withDefault(drift.currentDateAndTime)();

  @override
  Set<drift.Column<Object>> get primaryKey => {id};
}

/// Represents a user entity.
@freezed
abstract class UserEntity with _$UserEntity {
  const UserEntity._();

  @Assert('id.isNotEmpty', 'User id cannot be empty')
  factory UserEntity({
    /// Unique identifier for the user (UUID).
    required String id,

    /// Username of the user.
    required String username,

    /// Email address of the user.
    required String email,

    /// Timestamp when the user was created.
    required DateTime createdAt,

    /// Timestamp when the user was last updated.
    required DateTime updatedAt,
  }) = _UserEntity;


  /// Converts the [UserEntity] to a [UserTableCompanion] for database operations.
  UserTableCompanion toCompanion() {
    return UserTableCompanion(
      id: drift.Value(id),
      username: drift.Value(username),
      email: drift.Value(email),
      createdAt: drift.Value(createdAt),
      updatedAt: drift.Value(updatedAt),
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  static Future<List<UserEntity>> fromJsonArray(List jsonArray) async {
    return jsonArray.map((json) => UserEntity.fromJson(json)).toList();
  }
}