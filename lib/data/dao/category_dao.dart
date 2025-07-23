
import '../database.dart';
import '../models/category.dart';

class CategoryDao {

  static Future<void> saveSingleCategory(CategoryEntity category) async {
    AppDatabase db = AppDatabase.instance();
    await db.into(db.categoryTable).insertOnConflictUpdate(category.toCompanion());
  }

  static Future<void> saveListOfCategories(List<CategoryEntity> categories) async {
    AppDatabase db = AppDatabase.instance();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.categoryTable,
        categories.map((category) => category.toCompanion()).toList(),
      );
    });
  }

  static Future<List<CategoryEntity>> getAllCategories() async {
    AppDatabase db = AppDatabase.instance();
    return await db.select(db.categoryTable).get();
  }
  static Future<CategoryEntity?> getCategoryById(int id) async {
    AppDatabase db = AppDatabase.instance();
    return await (db.select(db.categoryTable)..where((category) => category.id.equals(id))).getSingleOrNull();
  }
  static Future<void> deleteCategoryById(int id) async {
    AppDatabase db = AppDatabase.instance();
    await (db.delete(db.categoryTable)..where((category) => category.id.equals(id))).go();
  }
}