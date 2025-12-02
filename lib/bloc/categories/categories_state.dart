part of 'categories_bloc.dart';

class CategoriesState extends Equatable {

  const CategoriesState({
    this.listStatus = .initial,
    List<CategoryWithCount>? categoriesWithCount,
    List<CategoryEntity>? categories,
    this.categoryDeletionStatus = .initial,
  }) : categoriesWithCount = categoriesWithCount ?? const [],
       categories = categories ?? const [];

  /// Current status of the categories list
  final UIStatusEnum listStatus;

  /// List of categories along with their usage count
  final List<CategoryWithCount> categoriesWithCount;

  /// List of all categories
  final List<CategoryEntity> categories;

  /// The deletion status of the category
  final UIStatusEnum categoryDeletionStatus;


  @override
  List<Object?> get props => [
    listStatus,
    categoriesWithCount,
    categories,
    categoryDeletionStatus,
  ];

  CategoriesState copyWith({
    List<CategoryWithCount>? categoriesWithCount,
    List<CategoryEntity>? categories,
    UIStatusEnum? listStatus,
    UIStatusEnum? categoryDeletionStatus,
  }) {
    return CategoriesState(
      categoriesWithCount: categoriesWithCount ?? this.categoriesWithCount,
      categories: categories ?? this.categories,
      listStatus: listStatus ?? this.listStatus,
      categoryDeletionStatus: categoryDeletionStatus ?? this.categoryDeletionStatus,
    );
  }
}