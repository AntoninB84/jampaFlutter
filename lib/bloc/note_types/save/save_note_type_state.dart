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

  final NoteTypeEntity? noteType;
  final NameValidator name;
  final bool isValidName;
  final bool existsAlready;
  final bool isLoading;
  final bool isError;
  final bool isSuccess;

  @override
  List<Object?> get props => [noteType, name, isValidName, existsAlready, isLoading, isError, isSuccess];

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