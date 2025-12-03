import '../models/category/category.dart';

/// A data class that combines a [CategoryEntity]
/// with the count of notes associated with it.
class CategoryWithCount {
  final CategoryEntity category;
  final int noteCount;

  CategoryWithCount({
    required this.category,
    required this.noteCount,
  });

  @override
  String toString() {
    return 'CategoryWithCount{category: $category, noteCount: $noteCount}';
  }
}