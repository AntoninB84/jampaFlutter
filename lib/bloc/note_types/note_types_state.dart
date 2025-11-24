part of 'note_types_bloc.dart';

enum NoteTypesListStatus {
  initial,
  success,
  error,
  loading,
}

extension NoteTypesListStatusX on NoteTypesListStatus {
  bool get isInitial => this == NoteTypesListStatus.initial;
  bool get isSuccess => this == NoteTypesListStatus.success;
  bool get isError => this == NoteTypesListStatus.error;
  bool get isLoading => this == NoteTypesListStatus.loading;
}

class NoteTypesState extends Equatable {

  const NoteTypesState({
    this.listStatus = NoteTypesListStatus.initial,
    List<NoteTypeEntity>? noteTypes,
    List<NoteTypeWithCount>? noteTypesWithCount,
    this.deletionError = false,
    this.deletionSuccess = false,
  }) : noteTypes = noteTypes ?? const [],
       noteTypesWithCount = noteTypesWithCount ?? const [];

  /// The current status of the note types list.
  final NoteTypesListStatus listStatus;

  /// The list of note types.
  final List<NoteTypeEntity> noteTypes;

  /// The list of note types along with their associated note counts.
  final List<NoteTypeWithCount> noteTypesWithCount;

  /// Indicates if there was an error during deletion of a note type.
  final bool deletionError;

  /// Indicates if the deletion of a note type was successful.
  final bool deletionSuccess;


  @override
  List<Object?> get props => [
    listStatus,
    noteTypes,
    noteTypesWithCount,
    deletionError,
    deletionSuccess
  ];

  NoteTypesState copyWith({
    List<NoteTypeEntity>? noteTypes,
    List<NoteTypeWithCount>? noteTypesWithCount,
    NoteTypesListStatus? listStatus,
    bool? deletionError,
    bool? deletionSuccess,
  }) {
    return NoteTypesState(
      noteTypes: noteTypes ?? this.noteTypes,
      noteTypesWithCount: noteTypesWithCount ?? this.noteTypesWithCount,
      listStatus: listStatus ?? this.listStatus,
      deletionError: deletionError ?? this.deletionError,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
    );
  }
}