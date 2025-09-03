part of 'edit_note_bloc.dart';

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
    this.singleDates = const [],
    this.recurrentDates = const [],
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

  final List<SingleDateFormElements> singleDates;
  final List<RecurrenceFormElements> recurrentDates;


  
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
    singleDates,
    recurrentDates,
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
    List<SingleDateFormElements>? singleDates,
    List<RecurrenceFormElements>? recurrentDates,
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
      singleDates: singleDates ?? this.singleDates,
      recurrentDates: recurrentDates ?? this.recurrentDates,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}