
import 'package:drift/drift.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../database.dart';
import '../models/category.dart';

/// Data Access Object (DAO) for [CategoryEntity]
class CategoryDao {

  /// Saves a single category to the database.
  static Future<void> saveSingleCategory(CategoryEntity category) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.into(db.categoryTable).insertOnConflictUpdate(category.toCompanion());
  }

  /// Saves a list of categories to the database in a batch operation.
  static Future<void> saveListOfCategories(List<CategoryEntity> categories) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.categoryTable,
        categories.map((category) => category.toCompanion()).toList(),
      );
    });
  }

  /// Retrieves categories by their IDs.
  static Future<List<CategoryEntity>> getCategoriesByIds(List<String> ids) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..where((category) => category.id.isIn(ids))..orderBy([(t)=>OrderingTerm(expression: t.name)])).get();
  }

  /// Retrieves all categories from the database, ordered by name.
  static Future<List<CategoryEntity>> getAllCategories() async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..orderBy([(t)=>OrderingTerm(expression: t.name)])).get();
  }

  /// Watches all categories in the database, ordered by name, emitting updates when changes occur.
  static Stream<List<CategoryEntity>> watchAllCategories() {
    AppDatabase db = serviceLocator<AppDatabase>();
    return (db.select(db.categoryTable)..orderBy([(t)=>OrderingTerm(expression: t.name)])).watch();
  }

  /// Watches categories along with their associated note counts.
  static Stream<List<CategoryWithCount>> watchCategoriesWithUseCount() {
    AppDatabase db = serviceLocator<AppDatabase>();
    // Constructing a query to get categories with their associated note counts
    final query = (db.select(db.categoryTable)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .join([
          leftOuterJoin(
            db.noteCategoryTable,
            db.noteCategoryTable.categoryId.equalsExp(db.categoryTable.id),
          ),
        ])
      ..addColumns([db.noteCategoryTable.noteId.count()])
      ..groupBy([db.categoryTable.id]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final category = row.readTable(db.categoryTable);
        final count = row.read(db.noteCategoryTable.noteId.count());
        return CategoryWithCount(category: category, noteCount: count ?? 0);
      }).toList();
    });
  }

  /// Retrieves a category by its ID.
  static Future<CategoryEntity?> getCategoryById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..where((category) => category.id.equals(id))).getSingleOrNull();
  }

  /// Retrieves a category by its name.
  static Future<CategoryEntity?> getCategoryByName(String name) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    return await (db.select(db.categoryTable)..where((category) => category.name.equals(name))).getSingleOrNull();
  }

  /// Deletes a category by its ID.
  static Future<void> deleteCategoryById(String id) async {
    AppDatabase db = serviceLocator<AppDatabase>();
    await (db.delete(db.categoryTable)..where((category) => category.id.equals(id))).go();
  }
}