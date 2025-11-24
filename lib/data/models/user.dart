
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../database.dart';

/// Represents the 'user' table in the database.
@UseRowClass(UserEntity)
class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().withLength(min: 1, max: 50)();
  TextColumn get email => text().withLength(min: 1, max: 100)();
  TextColumn get passwordHash => text().withLength(min: 1, max: 255)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Represents a user entity.
class UserEntity extends Equatable {

  /// Unique identifier for the user (UUID).
  String id;

  /// Username of the user.
  String username;

  /// Email address of the user.
  String email;

  /// Hashed password of the user.
  String passwordHash;

  /// Timestamp when the user was created.
  DateTime createdAt;

  /// Timestamp when the user was last updated.
  DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'UserEntity{id: $id, username: $username, email: $email, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  /// Converts the [UserEntity] to a [UserTableCompanion] for database operations.
  UserTableCompanion toCompanion() {
    return UserTableCompanion(
      id: Value(id),
      username: Value(username),
      email: Value(email),
      passwordHash: Value(passwordHash),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  UserEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        username = json['username'] as String,
        email = json['email'] as String,
        passwordHash = json['passwordHash'] as String,
        createdAt = DateTime.parse(json['createdAt'] as String),
        updatedAt = DateTime.parse(json['updatedAt'] as String);

  static Future<List<UserEntity>> fromJsonArray(List jsonArray) async {
    return jsonArray.map((json) => UserEntity.fromJson(json)).toList();
  }

  @override
  List<Object?> get props => [id];
}