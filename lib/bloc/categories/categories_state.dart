part of 'categories_bloc.dart';

enum CategoriesStatus {
  initial,
  success,
  error,
  loading,
}

extension CategoriesStatusX on CategoriesStatus {
  bool get isInitial => this == CategoriesStatus.initial;
  bool get isSuccess => this == CategoriesStatus.success;
  bool get isError => this == CategoriesStatus.error;
  bool get isLoading => this == CategoriesStatus.loading;
}

class CategoriesState extends Equatable {

  const CategoriesState({
    this.status = CategoriesStatus.initial,
    List<CategoryEntity>? categories,
    int idSelected = 0,
  }) : categories = categories ?? const [],
        idSelected = idSelected;

  final CategoriesStatus status;
  final List<CategoryEntity> categories;
  final int idSelected;

  @override
  List<Object?> get props => [status, categories, idSelected];

  CategoriesState copyWith({
    List<CategoryEntity>? categories,
    CategoriesStatus? status,
    int? idSelected,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      idSelected: idSelected ?? this.idSelected,
    );
  }
}