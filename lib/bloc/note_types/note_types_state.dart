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
    this.deletionError = false,
    this.deletionSuccess = false,
  }) : noteTypes = noteTypes ?? const [];

  final NoteTypesListStatus listStatus;
  final List<NoteTypeEntity> noteTypes;
  final bool deletionError;
  final bool deletionSuccess;


  @override
  List<Object?> get props => [listStatus, noteTypes, deletionError, deletionSuccess];

  NoteTypesState copyWith({
    List<NoteTypeEntity>? noteTypes,
    NoteTypesListStatus? listStatus,
    bool? deletionError,
    bool? deletionSuccess,
  }) {
    return NoteTypesState(
      noteTypes: noteTypes ?? this.noteTypes,
      listStatus: listStatus ?? this.listStatus,
      deletionError: deletionError ?? this.deletionError,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
    );
  }
}