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

  final CategoryEntity? category;
  final NameValidator name;
  final bool isValidName;
  final bool existsAlready;
  final bool isLoading;
  final bool isError;
  final bool isSuccess;

  @override
  List<Object?> get props => [category, name, isValidName, existsAlready, isLoading, isError, isSuccess];

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