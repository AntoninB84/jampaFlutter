part of 'note_form_bloc.dart';

enum NoteFormStatus {
  initial,
  loading,
  success,
  failure,
}

extension NoteFormStatusX on NoteFormStatus {
  bool get isInitial => this == NoteFormStatus.initial;
  bool get isLoading => this == NoteFormStatus.loading;
  bool get isSuccess => this == NoteFormStatus.success;
  bool get isFailure => this == NoteFormStatus.failure;
}

class NoteFormState extends Equatable {
  /// To determine how to handle calls to [SaveNoteBloc]
  final bool isSavingPersistentData;

  final String noteId;

  final NameValidator title;
  final bool isValidTitle;

  final Document? content;

  final NoteTypeEntity? selectedNoteType;

  final List<CategoryEntity> selectedCategories;

  final bool isImportantChecked;

  final NoteFormStatus status;

  const NoteFormState({
    this.isSavingPersistentData = false,
    required this.noteId,
    this.title = const NameValidator.pure(),
    this.isValidTitle = true,
    this.content,
    this.selectedNoteType,
    this.selectedCategories = const [],
    this.isImportantChecked = false,
    this.status = NoteFormStatus.initial,
  });

  @override
  List<Object?> get props => [
    isSavingPersistentData,
    noteId,
    title,
    isValidTitle,
    content,
    selectedNoteType,
    selectedCategories,
    isImportantChecked,
    status,
  ];

  NoteFormState copyWith({
    bool? isSavingPersistentData,
    String? noteId,
    NameValidator? title,
    bool? isValidTitle,
    Document? content,
    NoteTypeEntity? selectedNoteType,
    List<CategoryEntity>? selectedCategories,
    bool? isImportantChecked,
    NoteFormStatus? status,
  }) {
    return NoteFormState(
      isSavingPersistentData: isSavingPersistentData ?? this.isSavingPersistentData,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      isValidTitle: isValidTitle ?? this.isValidTitle,
      content: content ?? this.content,
      selectedNoteType: selectedNoteType ?? this.selectedNoteType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isImportantChecked: isImportantChecked ?? this.isImportantChecked,
      status: status ?? this.status,
    );
  }
}