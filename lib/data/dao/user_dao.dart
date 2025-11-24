
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/user.dart';

/// Data Access Object (DAO) for [UserEntity]
class UserDao {

  /// Saves a single user to the database.
  static Future<void> saveSingleUser(UserEntity user) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.into(db.userTable).insertOnConflictUpdate(user.toCompanion());
  }

  /// Saves a list of users to the database in a batch operation.
  static Future<void> saveListOfUsers(List<UserEntity> users) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.userTable,
        users.map((user) => user.toCompanion()).toList(),
      );
    });
  }

  /// Retrieves all users from the database.
  static Future<List<UserEntity>> getAllUsers() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await db.select(db.userTable).get();
  }

  /// Retrieves a user by their ID from the database.
  static Future<UserEntity?> getUserById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.userTable)..where((user) => user.id.equals(id))).getSingleOrNull();
  }

  /// Deletes a user by their ID from the database.
  static Future<void> deleteUserById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.userTable)..where((user) => user.id.equals(id))).go();
  }
}