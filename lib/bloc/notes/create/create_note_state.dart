part of 'create_note_cubit.dart';

class CreateNoteState extends Equatable {
  const CreateNoteState({
    this.title = const NameValidator.pure(),
    this.isValidTitle = true,
    this.content,
    this.selectedNoteType,
    this.selectedCategories = const [],
    this.isImportantChecked = false,
    this.selectedSingleDateElements = const [],
    this.selectedRecurrences = const [],
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
  });

  //Title
  final NameValidator title;
  final bool isValidTitle;
  //Content
  final Document? content;
  //Note Type
  final NoteTypeEntity? selectedNoteType;
  //Categories
  final List<CategoryEntity> selectedCategories;
  //Important
  final bool isImportantChecked;
  //Single date => No recurrence
  final List<SingleDateFormElements> selectedSingleDateElements;
  //Recurrence toggle
  final List<RecurrenceFormElements> selectedRecurrences;


  
  final bool isLoading;
  final bool isError;
  final bool isSuccess;

  @override
  List<Object?> get props => [
    title,
    isValidTitle,
    content,
    selectedNoteType,
    selectedCategories,
    isImportantChecked,
    selectedSingleDateElements,
    selectedRecurrences,
    isLoading,
    isError,
    isSuccess
  ];

  CreateNoteState copyWith({
    NameValidator? title,
    bool? isValidTitle,
    Document? content,
    NoteTypeEntity? selectedNoteType,
    List<CategoryEntity>? selectedCategories,
    bool? isImportantChecked,
    List<SingleDateFormElements>? selectedSingleDateElements,
    List<RecurrenceFormElements>? selectedRecurrences,
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return CreateNoteState(
      title: title ?? this.title,
      isValidTitle: isValidTitle ?? this.isValidTitle,
      content: content ?? this.content,
      selectedNoteType: selectedNoteType ?? this.selectedNoteType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isImportantChecked: isImportantChecked ?? this.isImportantChecked,
      selectedSingleDateElements: selectedSingleDateElements ?? this.selectedSingleDateElements,
      selectedRecurrences: selectedRecurrences ?? this.selectedRecurrences,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}