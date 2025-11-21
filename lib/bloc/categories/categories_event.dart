part of 'categories_bloc.dart';

class CategoriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class WatchCategories extends CategoriesEvent {}
final class WatchCategoriesWithCount extends CategoriesEvent {}

final class DeleteCategory extends CategoriesEvent {
  final String selectedCategoryId;

  DeleteCategory(this.selectedCategoryId);

  @override
  List<Object?> get props => [selectedCategoryId];
}