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
  final NoteStatus status;
  final bool deletionSuccess;
  final bool deletionFailure;

  const NoteState({
    this.note,
    this.status = NoteStatus.initial,
    this.deletionSuccess = false,
    this.deletionFailure = false,
  });

  @override
  List<Object?> get props => [note, status, deletionSuccess, deletionFailure];

  NoteState copyWith({
    NoteEntity? note,
    NoteStatus? status,
    bool? deletionSuccess,
    bool? deletionFailure,
  }) {
    return NoteState(
      note: note ?? this.note,
      status: status ?? this.status,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
      deletionFailure: deletionFailure ?? this.deletionFailure,
    );
  }

}