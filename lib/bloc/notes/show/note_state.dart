part of 'note_bloc.dart';

enum NoteStatus { initial, loading, success, failure }

extension NoteStatusX on NoteStatus {
  bool get isInitial => this == NoteStatus.initial;
  bool get isLoading => this == NoteStatus.loading;
  bool get isSuccess => this == NoteStatus.success;
  bool get isFailure => this == NoteStatus.failure;
}

class NoteState extends Equatable {

  final NoteEntity? note;
  final Document? noteContent;
  final NoteStatus status;
  final bool deletionSuccess;
  final bool deletionFailure;

  const NoteState({
    this.note,
    this.noteContent,
    this.status = NoteStatus.initial,
    this.deletionSuccess = false,
    this.deletionFailure = false,
  });

  @override
  List<Object?> get props => [
    note,
    noteContent,
    status,
    deletionSuccess,
    deletionFailure
  ];

  NoteState copyWith({
    NoteEntity? note,
    Document? noteContent,
    NoteStatus? status,
    bool? deletionSuccess,
    bool? deletionFailure,
  }) {
    return NoteState(
      note: note ?? this.note,
      noteContent: noteContent ?? this.noteContent,
      status: status ?? this.status,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
      deletionFailure: deletionFailure ?? this.deletionFailure,
    );
  }

}