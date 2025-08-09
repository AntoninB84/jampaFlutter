part of 'categories_bloc.dart';

class CategoriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class GetCategories extends CategoriesEvent {}

class SelectCategory extends CategoriesEvent {
  SelectCategory({
    required this.idSelected,
  });
  final int idSelected;

  @override
  List<Object?> get props => [idSelected];
}