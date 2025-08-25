part of 'create_note_cubit.dart';

class CreateNoteState extends Equatable {
  const CreateNoteState({
    this.note,
    this.title = const NameValidator.pure(),
    this.isValidTitle = true,
    this.content = const ContentValidator.pure(),
    this.isValidContent = true,
    this.selectedNoteType,
    this.selectedCategories = const [],
    this.isImportantChecked = false,
    this.selectedSingleStartDate,
    this.selectedSingleEndDate,
    this.singleDateAlarmElements,
    this.hasToggleRecurrence = false,
    this.selectedRecurrences = const [],
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
  //Single date => No recurrence
  final DateTime? selectedSingleStartDate;
  final DateTime? selectedSingleEndDate;
  final AlarmFormElements? singleDateAlarmElements;
  //Recurrence toggle
  final bool hasToggleRecurrence;
  final List<RecurrenceFormElements> selectedRecurrences;


  
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
    selectedSingleStartDate,
    selectedSingleEndDate,
    singleDateAlarmElements,
    hasToggleRecurrence,
    selectedRecurrences,
    isLoading,
    isError,
    isSuccess
  ];

  CreateNoteState copyWith({
    NoteEntity? note,
    NameValidator? title,
    bool? isValidTitle,
    ContentValidator? content,
    bool? isValidContent,
    NoteTypeEntity? selectedNoteType,
    List<CategoryEntity>? selectedCategories,
    bool? isImportantChecked,
    DateTime? selectedSingleStartDate,
    DateTime? selectedSingleEndDate,
    AlarmFormElements? singleDateAlarmElements,
    bool? hasToggleRecurrence,
    List<RecurrenceFormElements>? selectedRecurrences,
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return CreateNoteState(
      note: note ?? this.note,
      title: title ?? this.title,
      isValidTitle: isValidTitle ?? this.isValidTitle,
      content: content ?? this.content,
      isValidContent: isValidContent ?? this.isValidContent,
      selectedNoteType: selectedNoteType ?? this.selectedNoteType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isImportantChecked: isImportantChecked ?? this.isImportantChecked,
      selectedSingleStartDate: selectedSingleStartDate ?? this.selectedSingleStartDate,
      selectedSingleEndDate: selectedSingleEndDate ?? this.selectedSingleEndDate,
      singleDateAlarmElements: singleDateAlarmElements ?? this.singleDateAlarmElements,
      hasToggleRecurrence: hasToggleRecurrence ?? this.hasToggleRecurrence,
      selectedRecurrences: selectedRecurrences ?? this.selectedRecurrences,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}