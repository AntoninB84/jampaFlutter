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
    List<CategoryWithCount>? categoriesWithCount,
    List<CategoryEntity>? categories,
    this.deletionError = false,
    this.deletionSuccess = false,
  }) : categoriesWithCount = categoriesWithCount ?? const [],
       categories = categories ?? const [];

  /// Current status of the categories list
  final CategoriesListStatus listStatus;

  /// List of categories along with their usage count
  final List<CategoryWithCount> categoriesWithCount;

  /// List of all categories
  final List<CategoryEntity> categories;

  /// Indicates if there was an error during deletion
  final bool deletionError;

  /// Indicates if the deletion was successful
  final bool deletionSuccess;


  @override
  List<Object?> get props => [
    listStatus,
    categoriesWithCount,
    categories,
    deletionError,
    deletionSuccess
  ];

  CategoriesState copyWith({
    List<CategoryWithCount>? categoriesWithCount,
    List<CategoryEntity>? categories,
    CategoriesListStatus? listStatus,
    bool? deletionError,
    bool? deletionSuccess,
  }) {
    return CategoriesState(
      categoriesWithCount: categoriesWithCount ?? this.categoriesWithCount,
      categories: categories ?? this.categories,
      listStatus: listStatus ?? this.listStatus,
      deletionError: deletionError ?? this.deletionError,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
    );
  }
}