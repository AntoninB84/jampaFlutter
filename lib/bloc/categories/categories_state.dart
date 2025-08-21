part of 'categories_bloc.dart';

enum CategoriesListStatus {
  initial,
  success,
  error,
  loading,
}

extension CategoriesStatusX on CategoriesListStatus {
  bool get isInitial => this == CategoriesListStatus.initial;
  bool get isSuccess => this == CategoriesListStatus.success;
  bool get isError => this == CategoriesListStatus.error;
  bool get isLoading => this == CategoriesListStatus.loading;
}

class CategoriesState extends Equatable {

  const CategoriesState({
    this.status = CategoriesListStatus.initial,
    List<CategoryEntity>? categories,
  }) : categories = categories ?? const [];

  final CategoriesListStatus status;
  final List<CategoryEntity> categories;


  @override
  List<Object?> get props => [status, categories];

  CategoriesState copyWith({
    List<CategoryEntity>? categories,
    CategoriesListStatus? status,
    bool? displayDeleteConfirmation,
    CategoryEntity? categoryToDelete,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
    );
  }
}