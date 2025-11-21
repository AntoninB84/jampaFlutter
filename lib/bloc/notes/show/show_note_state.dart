part of 'show_note_bloc.dart';

enum NoteStatus { initial, loading, success, failure }

extension NoteStatusX on NoteStatus {
  bool get isInitial => this == NoteStatus.initial;
  bool get isLoading => this == NoteStatus.loading;
  bool get isSuccess => this == NoteStatus.success;
  bool get isFailure => this == NoteStatus.failure;
}

class ShowNoteState extends Equatable {

  final NoteEntity? note;
  final QuillController quillController;
  final List<ScheduleWithNextOccurrence> schedulesAndAlarms;
  final NoteStatus status;
  final NoteStatus schedulesLoadingStatus;
  final bool deletionSuccess;
  final bool deletionFailure;

  const ShowNoteState({
    this.note,
    required this.quillController,
    this.schedulesAndAlarms = const [],
    this.status = NoteStatus.initial,
    this.schedulesLoadingStatus = NoteStatus.initial,
    this.deletionSuccess = false,
    this.deletionFailure = false,
  });

  @override
  List<Object?> get props => [
    note,
    quillController,
    schedulesAndAlarms,
    status,
    schedulesLoadingStatus,
    deletionSuccess,
    deletionFailure
  ];

  ShowNoteState copyWith({
    NoteEntity? note,
    QuillController? quillController,
    List<ScheduleWithNextOccurrence> ?schedulesAndAlarms,
    NoteStatus? status,
    NoteStatus? schedulesLoadingStatus,
    bool? deletionSuccess,
    bool? deletionFailure,
  }) {
    return ShowNoteState(
      note: note ?? this.note,
      quillController: quillController ?? this.quillController,
      schedulesAndAlarms: schedulesAndAlarms ?? this.schedulesAndAlarms,
      status: status ?? this.status,
      schedulesLoadingStatus: schedulesLoadingStatus ?? this.schedulesLoadingStatus,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
      deletionFailure: deletionFailure ?? this.deletionFailure,
    );
  }

}