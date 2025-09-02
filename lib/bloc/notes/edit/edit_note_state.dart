part of 'edit_note_cubit.dart';

class EditNoteState extends Equatable {
  const EditNoteState({
    this.note,
    this.title = const NameValidator.pure(),
    this.isValidTitle = true,
    this.content = const ContentValidator.pure(),
    this.isValidContent = true,
    this.selectedNoteType,
    this.selectedCategories = const [],
    this.isImportantChecked = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
  });

  final NoteEntity? note;

  //Title
  final NameValidator title;
  final bool isValidTitle;
  //Content
  final ContentValidator content;
  final bool isValidContent;
  //Note Type
  final NoteTypeEntity? selectedNoteType;
  //Categories
  final List<CategoryEntity> selectedCategories;
  //Important
  final bool isImportantChecked;


  
  final bool isLoading;
  final bool isError;
  final bool isSuccess;

  @override
  List<Object?> get props => [
    note,
    title,
    isValidTitle,
    content,
    isValidContent,
    selectedNoteType,
    selectedCategories,
    isImportantChecked,
    isLoading,
    isError,
    isSuccess
  ];

  EditNoteState copyWith({
    NoteEntity? note,
    NameValidator? title,
    bool? isValidTitle,
    ContentValidator? content,
    bool? isValidContent,
    NoteTypeEntity? selectedNoteType,
    List<CategoryEntity>? selectedCategories,
    bool? isImportantChecked,
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return EditNoteState(
      note: note ?? this.note,
      title: title ?? this.title,
      isValidTitle: isValidTitle ?? this.isValidTitle,
      content: content ?? this.content,
      isValidContent: isValidContent ?? this.isValidContent,
      selectedNoteType: selectedNoteType ?? this.selectedNoteType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isImportantChecked: isImportantChecked ?? this.isImportantChecked,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}