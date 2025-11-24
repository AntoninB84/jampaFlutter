part of 'show_note_bloc.dart';

enum NoteStatus { initial, loading, success, failure }

extension NoteStatusX on NoteStatus {
  bool get isInitial => this == NoteStatus.initial;
  bool get isLoading => this == NoteStatus.loading;
  bool get isSuccess => this == NoteStatus.success;
  bool get isFailure => this == NoteStatus.failure;
}

class ShowNoteState extends Equatable {

  /// The note being displayed.
  final NoteEntity? note;

  /// The Quill controller for rich text editing of the note content.
  final QuillController quillController;

  /// List of schedules and their next occurrences associated with the note.
  final List<ScheduleWithNextOccurrence> schedulesAndReminders;

  /// The current status of note operations.
  final NoteStatus status;

  /// The current status of schedules loading operations.
  final NoteStatus schedulesLoadingStatus;

  /// Indicates if the note deletion was successful.
  final bool deletionSuccess;

  /// Indicates if the note deletion failed.
  final bool deletionFailure;

  const ShowNoteState({
    this.note,
    required this.quillController,
    this.schedulesAndReminders = const [],
    this.status = NoteStatus.initial,
    this.schedulesLoadingStatus = NoteStatus.initial,
    this.deletionSuccess = false,
    this.deletionFailure = false,
  });

  @override
  List<Object?> get props => [
    note,
    quillController,
    schedulesAndReminders,
    status,
    schedulesLoadingStatus,
    deletionSuccess,
    deletionFailure
  ];

  ShowNoteState copyWith({
    NoteEntity? note,
    QuillController? quillController,
    List<ScheduleWithNextOccurrence>? schedulesAndReminders,
    NoteStatus? status,
    NoteStatus? schedulesLoadingStatus,
    bool? deletionSuccess,
    bool? deletionFailure,
  }) {
    return ShowNoteState(
      note: note ?? this.note,
      quillController: quillController ?? this.quillController,
      schedulesAndReminders: schedulesAndReminders ?? this.schedulesAndReminders,
      status: status ?? this.status,
      schedulesLoadingStatus: schedulesLoadingStatus ?? this.schedulesLoadingStatus,
      deletionSuccess: deletionSuccess ?? this.deletionSuccess,
      deletionFailure: deletionFailure ?? this.deletionFailure,
    );
  }

}