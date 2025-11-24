part of 'categories_bloc.dart';

class CategoriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to watch all categories
final class WatchCategories extends CategoriesEvent {}

/// Event to watch categories along with their usage count
final class WatchCategoriesWithCount extends CategoriesEvent {}

/// Event to delete a specific category by its ID
final class DeleteCategory extends CategoriesEvent {
  final String selectedCategoryId;

  DeleteCategory(this.selectedCategoryId);

  @override
  List<Object?> get props => [selectedCategoryId];
}