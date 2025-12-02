part of 'note_form_bloc.dart';

class NoteFormState extends Equatable {

  /// Indicates whether the form is in editing mode (editing an existing note) or creating a new note.
  final bool isEditing;

  /// The unique identifier of the note being created or edited.
  final String noteId;

  /// The title of the note, validated using [NameValidator].
  final NameValidator title;

  /// The Quill controller managing the rich text content of the note.
  final QuillController quillController;

  /// The selected type of the note, if any.
  final NoteTypeEntity? selectedNoteType;

  /// The selected categories associated with the note, if any.
  final List<CategoryEntity> selectedCategories;

  /// Indicates whether the note is marked as important.
  final bool isImportantChecked;

  /// The current status of the note form.
  final UIStatusEnum status;

  const NoteFormState({
    this.isEditing = false,
    required this.noteId,
    this.title = const NameValidator.pure(),
    required this.quillController,
    this.selectedNoteType,
    this.selectedCategories = const [],
    this.isImportantChecked = false,
    this.status = .initial,
  });

  @override
  List<Object?> get props => [
    isEditing,
    noteId,
    title,
    quillController,
    selectedNoteType,
    selectedCategories,
    isImportantChecked,
    status,
  ];

  NoteFormState copyWith({
    bool? isEditing,
    String? noteId,
    NameValidator? title,
    QuillController? quillController,
    NoteTypeEntity? selectedNoteType,
    List<CategoryEntity>? selectedCategories,
    bool? isImportantChecked,
    UIStatusEnum? status,
  }) {
    return NoteFormState(
      isEditing: isEditing ?? this.isEditing,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      quillController: quillController ?? this.quillController,
      selectedNoteType: selectedNoteType ?? this.selectedNoteType,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isImportantChecked: isImportantChecked ?? this.isImportantChecked,
      status: status ?? this.status,
    );
  }

  /// Checks if the form is valid based on the title field.
  bool get isValidForm {
    return title.isValid && !title.isPure;
  }

  /// Determines if the form can be submitted based on its validity and loading status.
  bool get canSubmitForm {
    return isValidForm && !status.isLoading;
  }
}