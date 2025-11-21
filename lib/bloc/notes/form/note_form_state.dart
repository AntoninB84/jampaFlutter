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

  final QuillController quillController;

  final NoteTypeEntity? selectedNoteType;

  final List<CategoryEntity> selectedCategories;

  final bool isImportantChecked;

  final NoteFormStatus status;

  const NoteFormState({
    this.isSavingPersistentData = false,
    required this.noteId,
    this.title = const NameValidator.pure(),
    required this.quillController,
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
    quillController,
    selectedNoteType,
    selectedCategories,
    isImportantChecked,
    status,
  ];

  NoteFormState copyWith({
    bool? isSavingPersistentData,
    String? noteId,
    NameValidator? title,
    QuillController? quillController,
    NoteTypeEntity? selectedNoteType,
    List<CategoryEntity>? selectedCategories,
    bool? isImportantChecked,
    NoteFormStatus? status,
  }) {
    return NoteFormState(
      isSavingPersistentData: isSavingPersistentData ?? this.isSavingPersistentData,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      quillController: quillController ?? this.quillController,
      selectedNoteType: selectedNoteType ?? this.selectedNoteType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isImportantChecked: isImportantChecked ?? this.isImportantChecked,
      status: status ?? this.status,
    );
  }

  bool get isValidForm {
    return title.isValid && !title.isPure;
  }

  bool get canSubmitForm {
    return isValidForm && !status.isLoading;
  }
}