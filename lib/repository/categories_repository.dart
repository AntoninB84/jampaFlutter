
import 'package:jampa_flutter/data/dao/category_dao.dart';
import 'package:jampa_flutter/data/models/category.dart';

class CategoriesRepository {
  const CategoriesRepository();

  Future<List<CategoryEntity>> getCategories() async {
      return await CategoryDao.getAllCategories();
  }
  Stream<List<CategoryEntity>> getCategoriesStream() {
    return CategoryDao.getAllCategoriesStream();
  }
  Future<List<CategoryEntity>> getCategoriesByIds(List<int> ids) async {
    return await CategoryDao.getCategoriesByIds(ids);
  }

  Future<CategoryEntity?> getCategoryById(int id) async {
    return await CategoryDao.getCategoryById(id);
  }

  Future<CategoryEntity?> getCategoryByName(String name) async {
    return await CategoryDao.getCategoryByName(name);
  }

  Future<void> saveCategory(CategoryEntity category) async {
    await CategoryDao.saveSingleCategory(category);
  }

  Future<void> deleteCategory(int id) async {
    await CategoryDao.deleteCategoryById(id);
  }
}