part of 'categories_bloc.dart';

class CategoriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetCategories extends CategoriesEvent {}

final class ListenCategories extends CategoriesEvent {}

final class DeleteCategory extends CategoriesEvent {
  final int selectedCategoryId;

  DeleteCategory(this.selectedCategoryId);

  @override
  List<Object?> get props => [selectedCategoryId];
}