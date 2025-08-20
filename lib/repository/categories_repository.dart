
import 'package:jampa_flutter/data/dao/category_dao.dart';
import 'package:jampa_flutter/data/models/category.dart';

class CategoriesRepository {
  const CategoriesRepository();

  Future<List<CategoryEntity>> getCategories() async {
      List<CategoryEntity> result = await CategoryDao.getAllCategories();
      if (result.isEmpty) {
        // If no categories are found, return an empty list
        result = [
          CategoryEntity(
            id: 1,
            name: 'Test 1',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryEntity(
            id: 2,
            name: 'Test 2',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          CategoryEntity(
            id: 3,
            name: 'Test 3',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      }
      return result;
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
}