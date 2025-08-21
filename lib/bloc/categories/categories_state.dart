part of 'categories_bloc.dart';

enum CategoriesListStatus {
  initial,
  success,
  error,
  loading,
}

extension CategoriesListStatusX on CategoriesListStatus {
  bool get isInitial => this == CategoriesListStatus.initial;
  bool get isSuccess => this == CategoriesListStatus.success;
  bool get isError => this == CategoriesListStatus.error;
  bool get isLoading => this == CategoriesListStatus.loading;
}

class CategoriesState extends Equatable {

  const CategoriesState({
    this.listStatus = CategoriesListStatus.initial,
    List<CategoryEntity>? categories,
    this.deletionError = false,
    this.deletionSuccess = false,
  }) : categories = categories ?? const [];

  final CategoriesListStatus listStatus;
  final List<CategoryEntity> categories;
  final bool deletionError;
  final bool deletionSuccess;


  @override
  List<Object?> get props => [listStatus, categories, deletionError, deletionSuccess];

  CategoriesState copyWith({
    List<CategoryEntity>? categories,
    CategoriesListStatus? listStatus,
    bool? deletionError,
    bool? deletionSuccess,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      listStatus: listStatus ?? this.listStatus,
      deletionError: deletionError ?? this.deletionError,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
    );
  }
}