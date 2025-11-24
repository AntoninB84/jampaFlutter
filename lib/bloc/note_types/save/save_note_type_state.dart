part of 'save_note_type_cubit.dart';

class SaveNoteTypeState extends Equatable {
  const SaveNoteTypeState({
    this.noteType,
    this.name = const NameValidator.pure(),
    this.isValidName = true,
    this.existsAlready = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
  });

  /// The note type being created or edited.
  final NoteTypeEntity? noteType;

  /// The name validator for the note type's name.
  final NameValidator name;

  /// Whether the name is valid.
  final bool isValidName;

  /// Whether a note type with the same name already exists.
  final bool existsAlready;

  /// Whether the save operation is in progress.
  final bool isLoading;

  /// Whether there was an error during the save operation.
  final bool isError;

  /// Whether the save operation was successful.
  final bool isSuccess;

  @override
  List<Object?> get props => [
    noteType,
    name,
    isValidName,
    existsAlready,
    isLoading,
    isError,
    isSuccess
  ];

  SaveNoteTypeState copyWith({
    NoteTypeEntity? noteType,
    NameValidator? name,
    bool? isValidName,
    bool? existsAlready,
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
  }) {
    return SaveNoteTypeState(
      noteType: noteType ?? this.noteType,
      name: name ?? this.name,
      isValidName: isValidName ?? this.isValidName,
      existsAlready: existsAlready ?? this.existsAlready,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}