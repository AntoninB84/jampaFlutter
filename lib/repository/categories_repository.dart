
import 'package:jampa_flutter/data/dao/category_dao.dart';
import 'package:jampa_flutter/data/models/category.dart';

class CategoriesRepository {
  const CategoriesRepository();

  Future<List<CategoryEntity>> getCategories() async {
      return await CategoryDao.getAllCategories();
  }
  Stream<List<CategoryEntity>> watchAllCategories() {
    return CategoryDao.watchAllCategories();
  }
  Stream<List<CategoryWithCount>> watchCategoriesWithUseCount() {
    return CategoryDao().watchCategoriesWithUseCount();
  }

  Future<List<CategoryEntity>> getCategoriesByIds(List<String> ids) async {
    return await CategoryDao.getCategoriesByIds(ids);
  }

  Future<CategoryEntity?> getCategoryById(String id) async {
    return await CategoryDao.getCategoryById(id);
  }

  Future<CategoryEntity?> getCategoryByName(String name) async {
    return await CategoryDao.getCategoryByName(name);
  }

  Future<void> saveCategory(CategoryEntity category) async {
    await CategoryDao.saveSingleCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await CategoryDao.deleteCategoryById(id);
  }
}