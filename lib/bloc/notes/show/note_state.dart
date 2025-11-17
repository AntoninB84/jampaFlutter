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
  final List<ScheduleWithNextOccurrence> schedulesAndAlarms;
  final NoteStatus status;
  final NoteStatus schedulesLoadingStatus;
  final bool deletionSuccess;
  final bool deletionFailure;

  const NoteState({
    this.note,
    this.noteContent,
    this.schedulesAndAlarms = const [],
    this.status = NoteStatus.initial,
    this.schedulesLoadingStatus = NoteStatus.initial,
    this.deletionSuccess = false,
    this.deletionFailure = false,
  });

  @override
  List<Object?> get props => [
    note,
    noteContent,
    schedulesAndAlarms,
    status,
    schedulesLoadingStatus,
    deletionSuccess,
    deletionFailure
  ];

  NoteState copyWith({
    NoteEntity? note,
    Document? noteContent,
    List<ScheduleWithNextOccurrence> ?schedulesAndAlarms,
    NoteStatus? status,
    NoteStatus? schedulesLoadingStatus,
    bool? deletionSuccess,
    bool? deletionFailure,
  }) {
    return NoteState(
      note: note ?? this.note,
      noteContent: noteContent ?? this.noteContent,
      schedulesAndAlarms: schedulesAndAlarms ?? this.schedulesAndAlarms,
      status: status ?? this.status,
      schedulesLoadingStatus: schedulesLoadingStatus ?? this.schedulesLoadingStatus,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
      deletionFailure: deletionFailure ?? this.deletionFailure,
    );
  }

}