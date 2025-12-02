part of 'save_category_cubit.dart';

class SaveCategoryState extends Equatable {
  const SaveCategoryState({
    this.category,
    this.name = const NameValidator.pure(),
    this.isValidName = true,
    this.existsAlready = false,
    this.saveCategoryStatus = .initial,
  });

  /// The category being edited or created
  final CategoryEntity? category;

  /// The name input validator
  final NameValidator name;

  /// Indicates if the name input is valid
  final bool isValidName;
  /// Indicates if a category with the same name already exists
  final bool existsAlready;
  /// Indicates if a save operation is in progress or if data is being loaded
  final UIStatusEnum saveCategoryStatus;

  @override
  List<Object?> get props => [
    category,
    name,
    isValidName,
    existsAlready,
    saveCategoryStatus
  ];

  SaveCategoryState copyWith({
    CategoryEntity? category,
    NameValidator? name,
    bool? isValidName,
    bool? existsAlready,
    UIStatusEnum? saveCategoryStatus,
  }) {
    return SaveCategoryState(
      category: category ?? this.category,
      name: name ?? this.name,
      isValidName: isValidName ?? this.isValidName,
      existsAlready: existsAlready ?? this.existsAlready,
      saveCategoryStatus: saveCategoryStatus ?? this.saveCategoryStatus,
    );
  }
}