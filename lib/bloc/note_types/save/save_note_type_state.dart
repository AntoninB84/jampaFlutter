part of 'save_note_type_cubit.dart';

class SaveNoteTypeState extends Equatable {
  const SaveNoteTypeState({
    this.noteType,
    this.name = const NameValidator.pure(),
    this.isValidName = true,
    this.existsAlready = false,
    this.saveNoteTypeStatus = .initial
  });

  /// The note type being created or edited.
  final NoteTypeEntity? noteType;

  /// The name validator for the note type's name.
  final NameValidator name;

  /// Whether the name is valid.
  final bool isValidName;

  /// Whether a note type with the same name already exists.
  final bool existsAlready;

  /// The state of the operations
  final UIStatusEnum saveNoteTypeStatus;

  @override
  List<Object?> get props => [
    noteType,
    name,
    isValidName,
    existsAlready,
    saveNoteTypeStatus
  ];

  SaveNoteTypeState copyWith({
    NoteTypeEntity? noteType,
    NameValidator? name,
    bool? isValidName,
    bool? existsAlready,
    UIStatusEnum? saveNoteTypeStatus,
  }) {
    return SaveNoteTypeState(
      noteType: noteType ?? this.noteType,
      name: name ?? this.name,
      isValidName: isValidName ?? this.isValidName,
      existsAlready: existsAlready ?? this.existsAlready,
      saveNoteTypeStatus: saveNoteTypeStatus ?? this.saveNoteTypeStatus,
    );
  }
}