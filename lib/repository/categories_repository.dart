
import 'package:jampa_flutter/data/dao/category_dao.dart';
import 'package:jampa_flutter/data/models/category/category.dart';
import 'package:jampa_flutter/utils/storage/sync_storage_service.dart';
import 'package:jampa_flutter/utils/service_locator.dart';

import '../data/objects/category_with_count.dart';

/// Repository for managing [CategoryEntity] data.
class CategoriesRepository {
  const CategoriesRepository();

  /// Fetches all categories from the database, ordered by name.
  Future<List<CategoryEntity>> getCategories() async {
      return await CategoryDao.getAllCategories();
  }

  /// Watches all categories ordered by name, and emits updates when changes occur.
  Stream<List<CategoryEntity>> watchAllCategories() {
    return CategoryDao.watchAllCategories();
  }

  /// Watches categories along with their usage counts.
  Stream<List<CategoryWithCount>> watchCategoriesWithUseCount() {
    return CategoryDao.watchCategoriesWithUseCount();
  }

  /// Fetches categories by their IDs.
  Future<List<CategoryEntity>> getCategoriesByIds(List<String> ids) async {
    return await CategoryDao.getCategoriesByIds(ids);
  }

  /// Fetches a category by its ID.
  Future<CategoryEntity?> getCategoryById(String id) async {
    return await CategoryDao.getCategoryById(id);
  }

  /// Fetches a category by its name.
  Future<CategoryEntity?> getCategoryByName(String name) async {
    return await CategoryDao.getCategoryByName(name);
  }

  /// Saves a category to the database.
  Future<void> saveCategory(CategoryEntity category) async {
    await CategoryDao.saveSingleCategory(category);
  }

  /// Deletes a category by its ID.
  Future<void> deleteCategory(String id) async {
    await CategoryDao.deleteCategoryById(id);
    // Track deletion for sync
    try {
      final syncStorage = serviceLocator<SyncStorageService>();
      await syncStorage.addPendingDeletion('category', id);
    } catch (e) {
      // If sync storage is not available, continue without tracking
      print('Failed to track deletion for sync: $e');
    }
  }
}