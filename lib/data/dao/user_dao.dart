
import '../database.dart';
import '../models/user.dart';

class UserDao {
  static Future<void> saveSingleUser(UserEntity user) async {
    AppDatabase db = AppDatabase.instance();
    await db.into(db.userTable).insertOnConflictUpdate(user.toCompanion());
  }

  static Future<void> saveListOfUsers(List<UserEntity> users) async {
    AppDatabase db = AppDatabase.instance();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.userTable,
        users.map((user) => user.toCompanion()).toList(),
      );
    });
  }

  static Future<List<UserEntity>> getAllUsers() async {
    AppDatabase db = AppDatabase.instance();
    return await db.select(db.userTable).get();
  }

  static Future<UserEntity?> getUserById(int id) async {
    AppDatabase db = AppDatabase.instance();
    return await (db.select(db.userTable)..where((user) => user.id.equals(id))).getSingleOrNull();
  }

  static Future<void> deleteUserById(int id) async {
    AppDatabase db = AppDatabase.instance();
    await (db.delete(db.userTable)..where((user) => user.id.equals(id))).go();
  }
}