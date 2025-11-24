part of 'save_category_cubit.dart';

class SaveCategoryState extends Equatable {
  const SaveCategoryState({
    this.category,
    this.name = const NameValidator.pure(),
    this.isValidName = true,
    this.existsAlready = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
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
  final bool isLoading;
  /// Indicates if there was an error during the save operation
  final bool isError;
  /// Indicates if the save operation was successful
  final bool isSuccess;

  @override
  List<Object?> get props => [
    category,
    name,
    isValidName,
    existsAlready,
    isLoading,
    isError,
    isSuccess
  ];

  SaveCategoryState copyWith({
    CategoryEntity? category,
    NameValidator? name,
    bool? isValidName,
    bool? existsAlready,
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return SaveCategoryState(
      category: category ?? this.category,
      name: name ?? this.name,
      isValidName: isValidName ?? this.isValidName,
      existsAlready: existsAlready ?? this.existsAlready,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}