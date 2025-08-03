part of 'categories_bloc.dart';

enum CategoriesStatus {
  initial,
  success,
  failure,
}

class CategoriesState extends Equatable {

  const CategoriesState._({
    this.status = CategoriesStatus.initial,
    this.categories = const [],
    this.isLoading = false,
  });

  const CategoriesState.initial() : this._();

  const CategoriesState.loading(List<CategoryEntity> categories)
      : this._(categories: categories, isLoading: true);

  const CategoriesState.loaded(List<CategoryEntity> categories)
      : this._(categories: categories, isLoading: false);

  const CategoriesState.error(String message, List<CategoryEntity> categories)
      : this._(categories: categories, isLoading: false);

  const CategoriesState.empty()
      : this._(categories: const [], isLoading: false);


  final CategoriesStatus status;
  final List<CategoryEntity> categories;
  final bool isLoading;

  @override
  List<Object?> get props => [categories, isLoading];

}