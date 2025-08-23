
import 'package:drift/drift.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/category.dart';

class CategoryDao {

  static Future<void> saveSingleCategory(CategoryEntity category) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.into(db.categoryTable).insertOnConflictUpdate(category.toCompanion());
  }

  static Future<void> saveListOfCategories(List<CategoryEntity> categories) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.categoryTable,
        categories.map((category) => category.toCompanion()).toList(),
      );
    });
  }

  static Future<List<CategoryEntity>> getCategoriesByIds(List<int> ids) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..where((category) => category.id.isIn(ids))..orderBy([(t)=>OrderingTerm(expression: t.name)])).get();
  }

  static Future<List<CategoryEntity>> getAllCategories() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..orderBy([(t)=>OrderingTerm(expression: t.name)])).get();
  }
  static Stream<List<CategoryEntity>> watchAllCategories() {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.categoryTable)..orderBy([(t)=>OrderingTerm(expression: t.name)])).watch();
  }

  static Future<CategoryEntity?> getCategoryById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..where((category) => category.id.equals(id))).getSingleOrNull();
  }
  static Future<CategoryEntity?> getCategoryByName(String name) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..where((category) => category.name.equals(name))).getSingleOrNull();
  }

  static Future<void> deleteCategoryById(int id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.categoryTable)..where((category) => category.id.equals(id))).go();
  }
}