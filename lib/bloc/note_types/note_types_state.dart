part of 'note_types_bloc.dart';

class NoteTypesState extends Equatable {

  const NoteTypesState({
    this.listStatus = .initial,
    List<NoteTypeEntity>? noteTypes,
    List<NoteTypeWithCount>? noteTypesWithCount,
    this.noteTypeDeletionStatus = .initial,
  }) : noteTypes = noteTypes ?? const [],
       noteTypesWithCount = noteTypesWithCount ?? const [];

  /// The current status of the note types list.
  final UIStatusEnum listStatus;

  /// The list of note types.
  final List<NoteTypeEntity> noteTypes;

  /// The list of note types along with their associated note counts.
  final List<NoteTypeWithCount> noteTypesWithCount;

  /// The status of the operations.
  final UIStatusEnum noteTypeDeletionStatus;


  @override
  List<Object?> get props => [
    listStatus,
    noteTypes,
    noteTypesWithCount,
    noteTypeDeletionStatus,
  ];

  NoteTypesState copyWith({
    List<NoteTypeEntity>? noteTypes,
    List<NoteTypeWithCount>? noteTypesWithCount,
    UIStatusEnum? listStatus,
    UIStatusEnum? noteTypeDeletionStatus,
  }) {
    return NoteTypesState(
      noteTypes: noteTypes ?? this.noteTypes,
      noteTypesWithCount: noteTypesWithCount ?? this.noteTypesWithCount,
      listStatus: listStatus ?? this.listStatus,
      noteTypeDeletionStatus: noteTypeDeletionStatus ?? this.noteTypeDeletionStatus,
    );
  }
}